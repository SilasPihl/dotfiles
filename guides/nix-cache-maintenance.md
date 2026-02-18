# Nix Cache Maintenance Guide

## The Problem

Over time, Nix's local tarball cache accumulates hundreds of Git packfiles.
When the packfile count gets high enough, Git operations hit the OS
"Too many open files" limit, which causes `nix develop` to fail silently when
resolving `bashInteractive` from nixpkgs. On macOS this makes it fall back to
the ancient system `/bin/bash` (3.2), which cannot parse the shell init script
(it uses `declare -A` and `;&` — both bash 4+ features).

Symptoms:

```
error (ignored): writing packfile: -1, failed to open directory
  '~/.cache/nix/tarball-cache-v2/refs/': Too many open files

bash: declare: -A: invalid option
bash: syntax error near unexpected token `;'
bash:             ;&
```

## Quick Fix

Delete the tarball cache. Nix recreates it automatically on the next flake
operation (one-time cost of re-downloading flake inputs):

```bash
rm -rf ~/.cache/nix/tarball-cache-v2
```

## Full Cache Cleanup

Everything under `~/.cache/nix/` is a regenerable cache. None of it is
managed by `nix-collect-garbage` or `nix store gc` — those commands only
operate on `/nix/store`.

There is **no nix-native CLI command** to clean `~/.cache/nix/`. You must
delete directories manually.

### What each directory does

| Path                       | Purpose                                                  | Safe to delete?                      |
| -------------------------- | -------------------------------------------------------- | ------------------------------------ |
| `tarball-cache-v2/`        | Bare Git repo caching fetched flake inputs               | Yes — main culprit of packfile bloat |
| `tarball-cache/`           | Legacy (v1) tarball cache, no longer used by current Nix | Yes — purely stale                   |
| `eval-cache-v6/`           | Cached flake output evaluations                          | Yes — regenerated on next eval       |
| `eval-cache-v5/`           | Old eval cache version, unused if v6 exists              | Yes — purely stale                   |
| `fetcher-cache-v4.sqlite*` | SQLite DB mapping URLs to store paths                    | Yes — regenerated on next fetch      |
| `fetcher-cache-v3.sqlite*` | Old fetcher cache, unused if v4 exists                   | Yes — purely stale                   |
| `binary-cache-v7.sqlite`   | Narinfo cache for binary substituters                    | Yes — regenerated on next download   |
| `binary-cache-v6.sqlite*`  | Old binary cache, unused if v7 exists                    | Yes — purely stale                   |
| `flake-registry.json`      | Symlink to the global flake registry in the store        | Yes — re-fetched automatically       |

### How to tell which caches are stale

When Nix upgrades its internal cache format, it creates a new versioned
directory (e.g., `eval-cache-v5` → `eval-cache-v6`) and stops reading/writing
the old one. Two signals identify stale caches:

1. **Version suffixes** — if both `v5` and `v6` exist for the same cache
   type, the lower version is abandoned. Nix only uses the highest version.

2. **Last-modified timestamps** — stale caches stop being modified the
   moment Nix upgrades to a newer format. Run `ls -la ~/.cache/nix/` and
   compare dates. Active caches show recent timestamps; stale ones are
   frozen in the past.

Example (Determinate Nix 3.15.1 / Nix 2.33):

```
Active (recently modified)           Stale (not modified in weeks/months)
─────────────────────────────        ────────────────────────────────────
eval-cache-v6/        (today)        eval-cache-v5/        (weeks ago)
fetcher-cache-v4.sqlite (today)      fetcher-cache-v3.sqlite (weeks ago)
binary-cache-v7.sqlite  (recent)     binary-cache-v6.sqlite  (months ago)
tarball-cache-v2/       (today)      tarball-cache/          (months ago)
```

As a rule: if two versions of the same cache exist, the older one is dead
weight and can always be deleted.

### Nuclear option: delete everything

```bash
rm -rf ~/.cache/nix
```

This is safe. Nix will recreate all caches as needed. The only cost is
slightly slower first operations while caches are rebuilt.

### Conservative option: delete only stale and bloated caches

```bash
# Remove the bloated tarball caches
rm -rf ~/.cache/nix/tarball-cache-v2
rm -rf ~/.cache/nix/tarball-cache

# Remove old versioned caches superseded by newer ones
rm -rf ~/.cache/nix/eval-cache-v5
rm -f  ~/.cache/nix/fetcher-cache-v3.sqlite*
rm -f  ~/.cache/nix/binary-cache-v6.sqlite*
```

## Diagnosing the Problem

Check if your tarball cache has too many packfiles:

```bash
git -C ~/.cache/nix/tarball-cache-v2 count-objects -v 2>/dev/null | grep packs
```

A healthy cache has single-digit packs. Hundreds of packs means trouble.

## Applies to Both macOS and NixOS

This issue affects any machine running Nix with flakes over time. The cache
path is the same on both macOS and NixOS (`~/.cache/nix/`). Check and clean
both machines if you develop on multiple systems.

## Difference from `nix-collect-garbage`

| Command                                | What it cleans                                  | When to use                                    |
| -------------------------------------- | ----------------------------------------------- | ---------------------------------------------- |
| `nix-collect-garbage -d`               | `/nix/store` (unused derivations, old profiles) | Reclaim disk space from built packages         |
| `nix store gc`                         | `/nix/store` (same as above, newer CLI)         | Same as above                                  |
| `rm -rf ~/.cache/nix/tarball-cache-v2` | Flake input download cache                      | Fix "Too many open files" / slow `nix develop` |
| `rm -rf ~/.cache/nix`                  | All Nix user caches                             | Full reset of all caches                       |

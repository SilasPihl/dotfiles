# Nix managed dotfiles

## Prerequisites

```bash
# enable experimental features
mkdir -p ~/.config/nix
cat <<EOF > ~/.config/nix/nix.conf
experimental-features = flakes nix-command
EOF

```

## Apply configuration

### DevOS Virtual Machine (`aarch64-linux`)

```bash
sudo nixos-rebuild switch --flake github:sebastianballe/dotfiles#devos --impure
nix run home-manager/master -- switch --flake github:sebastianballe/dotfiles#mac
```

### Sebastian's MacBook Pro Laptop (`aarch64-darwin`)

```bash
nix run home-manager/master -- switch --flake github:sebastianballe/dotfiles#mac
```
## Nix-darwin installation (Not used anymore)

See `/docs/nix-darwin-installation.md`


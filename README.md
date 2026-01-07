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
sudo nixos-rebuild switch --flake github:silaspihl/dotfiles#devos --impure
nix run home-manager/master -- switch --flake github:silaspihl/dotfiles#mac
```

### Silas Pihl's MacBook Pro Laptop (`aarch64-darwin`)

```bash
nix run home-manager/master -- switch --flake github:silaspihl/dotfiles#mac

NAME=mac task home-manager:switch
```

Key repeat stroke on MacOS is slow. Increase it by following the guide: https://linkarzu.com/posts/2024-macos-workflow/macos-keyrepeat-rate/.

## Claude Code MCP Servers

```bash
# Context7 - documentation lookup
claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp

# Playwright - browser automation
claude mcp add --scope user playwright -- npx @playwright/mcp@latest

# Chrome DevTools - browser debugging
claude mcp add --scope user chrome-devtools -- npx -y chrome-devtools-mcp
```
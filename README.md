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

## Manual Installations

Some applications need to be installed manually (not managed by Nix):

### Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Casks

```bash
brew install --cask android-platform-tools ngrok raycast visual-studio-code
```

### Direct Downloads

| App | URL | Notes |
|-----|-----|-------|
| f.lux | https://justgetflux.com/news/pages/macquickstart/ | Display color temperature |
| Ghostty | https://ghostty.org/ | Terminal emulator (config managed by Nix) |
| Cursor | https://cursor.sh/ | AI code editor |
| Docker | https://www.docker.com/products/docker-desktop/ | Docker Desktop |
| Obsidian | https://obsidian.md/ | Notes |
| Spotify | https://www.spotify.com/download/ | Music (spicetify config in Nix) |
| Claude | https://claude.ai/download | AI assistant |
| ChatGPT | https://openai.com/chatgpt/mac/ | AI assistant |
| NordVPN | https://nordvpn.com/download/ | VPN |
| Wispr Flow | https://www.wispr.ai/ | Voice typing |
| Beeper | https://www.beeper.com/ | Unified messaging |
| Nextcloud | https://nextcloud.com/install/ | Cloud sync |
| Firefox | https://www.mozilla.org/firefox/ | Browser |
| Google Chrome | https://www.google.com/chrome/ | Browser |
| Vivaldi | https://vivaldi.com/ | Browser |
| Zen | https://zen-browser.app/ | Browser |
| Sublime Text | https://www.sublimetext.com/ | Text editor |
| GitHub Desktop | https://desktop.github.com/ | Git GUI |
| Adobe Acrobat | https://www.adobe.com/acrobat.html | PDF reader |
| CapCut | https://www.capcut.com/ | Video editor |

### App Store

- 1Password
- Xcode
- Slack
- WhatsApp
- Microsoft Excel
- Microsoft Teams
- Microsoft Word
- Notion
- Reflect
- Mem
- Crystal
- Exporter
- Willow Voice
- Locklizard Safeguard Viewer

## Claude Code MCP Servers

```bash
# Context7 - documentation lookup
claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp

# Playwright - browser automation
claude mcp add --scope user playwright -- npx @playwright/mcp@latest

# Chrome DevTools - browser debugging
claude mcp add --scope user chrome-devtools -- npx -y chrome-devtools-mcp
```
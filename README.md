# Nix managed dotfiles

## Prerequisites

```bash
# enable experimental features
mkdir -p ~/.config/nix
cat <<EOF > ~/.config/nix/nix.conf
experimental-features = flakes nix-command
EOF

# install nix package manager (assume done)

# install home-manager on non-NixOS
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# install home-manager on NixOS
nix-env -iA nixos.home-manager
```

## Apply configuration

### DevOS Virtual Machine (`aarch64-linux`)

```bash
sudo nixos-rebuild switch --flake github:sebastianballe/dotfiles#devos --impure
nix-env -iA home-manager
home-manager switch --flake github:sebastianballe/dotfiles#devos
```

### Sebastian's MacBook Pro Laptop (`aarch64-darwin`)

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
home-manager switch --flake github:sebastianballe/dotfiles#mac
```
## Nix-darwin installation (Not used anymore)

See `/docs/nix-darwin-installation.md`


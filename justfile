mac:
  nix run home-manager/master -- switch --flake .#mac --impure

update:
  nix flake update

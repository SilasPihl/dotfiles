{ pkgs, pkgs-stable, system, user, ... }:
{
  imports = [./spicetify.nix ];

  home.packages = with pkgs;
    builtins.filter (pkg: pkg != null) [
      _1password-cli
      age
      alejandra
      bat
      cowsay
      direnv
      discord
      docker
      docker-credential-helpers
      eza
      flux
      fortune
      go-task
      gh
      glab
      kubectl
      lazydocker
      manix
      neovim
      ollama
      raycast
      podman
      podman-compose
      podman-tui
      sops
      stow
      stylua
      timetrap
      vim
      vivid
      xclip
      spotify
      _1password-cli
    ]
    ++ (with pkgs-stable; [ obsidian ]);
}
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
      docker
      docker-credential-helpers
      dotnetCorePackages.sdk_9_0_1xx
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
      nodejs_23
      ollama
      raycast
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
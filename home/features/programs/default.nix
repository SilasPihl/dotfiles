{ pkgs, pkgs-stable, system, user, ... }:
{
  imports = [ ./sesh.nix ./spicetify.nix ];

  home.packages = with pkgs;
    builtins.filter (pkg: pkg != null) [
      _1password-cli
      age
      alejandra
      bat
      cowsay
      direnv
      docker-credential-helpers
      eza
      flux
      fortune
      go
      go-task
      gh
      glab
      kubectl
      lazydocker
      manix
      nodejs_23
      ollama
      raycast
      rubyPackages.bigdecimal
      sops
      stow
      stylua
      timetrap
      vim
      vivid
      xclip
      (if system != "aarch64-linux" then spotify else null)
      (if system != "aarch64-linux" then zoom-us else null)
    ]
    ++ (with pkgs-stable; [ obsidian ]);
}
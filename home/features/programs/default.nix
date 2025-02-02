{ pkgs, pkgs-stable, system, user, ... }:
{
  imports = [ ./sesh.nix ./spicetify.nix ];

  home.packages = with pkgs;
    builtins.filter (pkg: pkg != null) [
      _1password-cli
      age
      alejandra
      bat
      direnv
      docker-credential-helpers
      eza
      flux
      go
      go-task
      kubectl
      lazydocker
      manix
      nodejs_23
      ollama
      gh
      raycast
      glab
      sops
      stow
      stylua
      timetrap
      rubyPackages.bigdecimal
      vim
      vivid
      xclip
      (if system != "aarch64-linux" then slack else null)
      (if system != "aarch64-linux" then spotify else null)
      (if system != "aarch64-linux" then zoom-us else null)
    ]
    ++ (with pkgs-stable; [ obsidian ]);
}
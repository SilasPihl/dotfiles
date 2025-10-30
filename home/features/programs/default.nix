{ pkgs, pkgs-stable, system, user, claude-code, hammerspoon, ... }:
{
  imports = [ ./spicetify.nix ./claude-code.nix ./hammerspoon.nix ];


  home.packages = with pkgs;
    builtins.filter (pkg: pkg != null) [
      #_1password-cli
      #age
      #alejandra
      bat
      #cowsay
      #direnv
      discord
      #docker
      #docker-credential-helpers
      eza
      #flux
      #fortune
      go-task
      gh
      #glab
      hammerspoon
      insomnia
      kubectl
      #ice-bar
      #lazydocker
      #manix
      monitorcontrol
      #neovim
      nodejs_22
      #ollama
      #raycast  # Managed via Homebrew for faster updates
      podman
      podman-compose
      podman-tui
      postman
      sesh
      sops
      stow
      #stylua
      #timetrap
      #vim
      vivid
      #xclip
      #spotify
      #_1password-cli
    ];
    #++ (with pkgs-stable; [ obsidian ]);
}
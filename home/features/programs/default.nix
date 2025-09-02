{ pkgs, pkgs-stable, system, user, claude-code, ... }:
{
  imports = [./spicetify.nix ./claude-code.nix ];


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
      kubectl
      #ice-bar
      #lazydocker
      #manix
      #neovim
      nodejs_22
      #ollama
      #raycast
      podman
      podman-compose
      podman-tui
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
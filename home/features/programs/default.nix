{ pkgs, pkgs-stable, system, user, claude-code, hammerspoon, ... }:
{
  imports = [ ./spicetify.nix ./claude-code.nix ./hammerspoon.nix ./opencode.nix ];


  home.packages = with pkgs;
    builtins.filter (pkg: pkg != null) [
      #_1password-cli
      #age
      #alejandra
      bat

      # Documentation tools
      # Note: mkdocs-glightbox removed due to test failure with Python 3.13
      (python3.withPackages (ps: with ps; [
        mkdocs
        mkdocs-drawio-file
        mkdocs-linkcheck
        mkdocs-material
        mkdocs-material-extensions
        mkdocs-mermaid2-plugin
        mkdocs-minify-plugin
      ]))
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
      git-town
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
      pnpm
      #ollama
      #raycast  # Managed via Homebrew for faster updates
      podman
      podman-compose
      podman-tui
      postman
      ruff
      sesh
      sops
      stow
      #stylua
      #timetrap
      uv
      #vim
      vivid
      watch
      #xclip
      #spotify
      #_1password-cli
      yq
      yt-dlp
    ];
    #++ (with pkgs-stable; [ obsidian ]);
}
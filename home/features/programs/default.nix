{
  pkgs,
  pkgs-stable,
  system,
  user,
  ...
}: {
  imports = [./sesh.nix ./spicetify.nix];

  home.packages = with pkgs;
    builtins.filter (pkg: pkg != null) [
      docker-credential-helpers
      flux
      kubectl
      lazydocker
      manix
      go-task
      ollama
      go
      nodejs_23
      raycast
      sops
      stylua
      alejandra
      stow
      (
        if system != "aarch64-linux"
        then slack
        else null
      )
      (
        if system != "aarch64-li pnux"
        then spotify
        else null
      )
      vim
      vivid
      xclip
      (
        if system != "aarch64-linux"
        then zoom-us
        else null
      )
    ]
    ++ (with pkgs-stable; [obsidian]);
}
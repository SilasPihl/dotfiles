{ pkgs, pkgs-stable, system, ... }: {
  home.packages = with pkgs;
    builtins.filter (pkg: pkg != null) [
      docker-credential-helpers
      flux
      kubectl
      lazydocker
      manix
      nerdfonts
      ollama
      raycast
      sesh
      (if system != "aarch64-linux" then slack else null)
      (if system != "aarch64-li pnux" then spotify else null)
      spicetify-cli
      vim
      vivid
      xclip
      (if system != "aarch64-linux" then zoom-us else null)
    ] ++ (with pkgs-stable; [ obsidian ]);
}

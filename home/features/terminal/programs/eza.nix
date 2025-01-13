{pkgs, ...}: {
  programs.eza = {
    enable = false;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--long"
    ];
  };
}
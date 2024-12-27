{pkgs, ...}: {
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--no-user"
      "--long"
      "--no-permissions"
      "--no-filesize"
    ];
  };
}

{ pkgs, ... }:
let
  # https://github.com/nix-community/home-manager/issues/6295#issuecomment-2597644501
  ghostty-mock = pkgs.writeShellScriptBin "ghostty-mock" ''
    true
  '';
in
{
  programs.ghostty = {
    enable = true;
    package = ghostty-mock; # Explicitly set the package to the mock script
    enableZshIntegration = true;
    installBatSyntax = true;
    settings = {
      theme = "catppuccin-macchiato";
      window-decoration = false;
      macos-titlebar-style = "hidden";
      macos-window-shadow = true;
      clipboard-read = "allow";
      clipboard-write = "allow";
    };
  };
}

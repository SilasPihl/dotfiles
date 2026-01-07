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
    enableBashIntegration = true;
    installBatSyntax = true;
    installVimSyntax = true;
    settings = {
      theme = "Catppuccin Macchiato";
      window-decoration = false;
      macos-titlebar-style = "hidden";
      macos-window-shadow = true;
      macos-option-as-alt = true;
      clipboard-read = "allow";
      clipboard-write = "allow";
      desktop-notifications = true;
    };
  };
}
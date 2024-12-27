{
  pkgs,
  user,
  ...
}: {
  xdg.configFile."ghostty/config".text = ''
       theme = catppuccin-macchiato
    window-decoration = false
    macos-titlebar-style = hidden
    macos-window-shadow = true

    clipboard-read = allow
    clipboard-write = allow

    shell-integration = zsh
  '';
}
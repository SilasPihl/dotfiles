{
  pkgs,
  lib,
  ...
}: {
  programs.yazi = {
    enable = true;
    flavors = {
      "catppuccin-macchiato" = ../../../../themes/yazi;
    };
    enableZshIntegration = true;
    # Launches yazi and drops in current dir on exit
    # See: https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
    shellWrapperName = "f";
    settings = {
      manager = {
        linemode = "size";
        show_hidden = true;
        show_symlink = true;
        sort_by = "natural";
        ratio = [
          1
          3
          5
        ];
      };
      preview = {
        tab_size = 2;
        max_width = 1000;
        max_height = 1000;
      };
      opener = {
        edit = [
          {
            block = true;
            run = ''nvim "$@"'';
          }
        ];
      };
    };
  };
}

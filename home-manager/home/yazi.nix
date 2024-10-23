{ config, pkgs, lib, ... }:

{
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        manager = {
          linemode = "size";
          show_hidden = true;
          show_symlink = true;
          sort_by = "natural";
          ratio = [1 3 5];
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
              run = "nvim \"$@\"";
            }
          ];
        };
      };
      theme = lib.importTOML ~/dotfiles/yazi/theme.toml;
    };
}

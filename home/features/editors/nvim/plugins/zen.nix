{ pkgs, ... }:

{
  plugins.zen-mode = {
    enable = true;
    settings = {
      plugins = {
        gitsigns = { enabled = true; };
        options = {
          enabled = true;
          ruler = false;
          showcmd = false;
        };
        tmux = { enabled = false; };
        twilight = { enabled = true; };
        kitty = { enabled = true; };
      };
    };
  };
}

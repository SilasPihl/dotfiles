{ pkgs, ... }:

{
  plugins.zen-mode = {
    enable = true;
    settings = {
      plugins = {
        twilight = {
          enabled = true;
        };
        kitty = {
          enabled = true;
        };
      };
    };
  };

}

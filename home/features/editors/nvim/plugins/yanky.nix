{ pkgs, ... }:

{
  plugins.yanky = {
    enable = true;
    enableTelescope = true;
    settings = {
      highlight = {
        on_put = true;
        on_yank = true;
        timer = 250;
      };
    };
  };
}

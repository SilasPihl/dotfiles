{ pkgs, ... }:

{
  plugins.twilight = {
    enable = true;
    settings = {
      context = 20;
      dimming = { alpha = 0.5; };
    };
  };
}

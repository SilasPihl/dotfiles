{ pkgs, ... }:

{
  plugins.noice = {
    enable = true;
    settings.notify.enabled = false;
  };
}

{ pkgs, ... }:

{
  plugins.undotree = {
    enable = true;
    settings = {
      FocusOnToggle = true;
      WindowLayout = 2;
    };
  };
}

{ pkgs, ... }:

{
  plugins.neotest = {
    enable = true;
    adapters.go = {
      enable = true;
      settings = { testFlags = [ "-tags=unit,integration" ]; };
    };
  };
}

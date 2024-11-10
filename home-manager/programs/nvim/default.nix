{ inputs, pkgs, user, ... }:

{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ./gp.nix ];
  programs.nixvim = let
    lib = pkgs.lib;
    opts = import ./opts.nix;

    pluginPaths = let pluginDir = ./plugins;
    in builtins.map (n: "${pluginDir}/${n}")
    (builtins.filter (n: builtins.match ".*\\.nix" n != null)
      (builtins.attrNames (builtins.readDir pluginDir)));

    combinedPlugins = lib.foldl'
      (acc: path: acc // (import path { inherit pkgs user; }).plugins) { }
      pluginPaths;

  in {
    enable = true;
    package = pkgs.neovim-unwrapped;
    extraPackages = with pkgs; [ gotools gofumpt delve ];

    plugins = combinedPlugins;
    inherit (opts) globals opts;

    editorconfig.enable = true;
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "macchiato";
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
        };
        term_colors = true;
      };
    };
    autoCmd = [{
      event = [ "BufWritePost" ];
      pattern = "*_test.go";
      command = '':lua require("neotest").run.run(vim.fn.expand("%")) '';
      desc = "Run Go tests on save for *_test.go files";
    }];
  };
}

{ inputs, pkgs, user, ... }:

let
  opts = import ./opts.nix;
  keymaps = import ./keymaps.nix;
  barbar = import ./plugins/barbar.nix { inherit pkgs; };
  cmp = import ./plugins/cmp.nix { inherit pkgs; };
  common = import ./plugins/common.nix { inherit pkgs user; };
  lsp = import ./plugins/lsp.nix { inherit pkgs; };
  neoTree = import ./plugins/neo-tree.nix { inherit pkgs; };
  telescope = import ./plugins/telescope.nix { inherit pkgs; };
  treesitter = import ./plugins/treesitter.nix { inherit pkgs; };
  whichKey = import ./plugins/which-key.nix { inherit pkgs; };
in {
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    extraPackages = with pkgs; [ gotools gofumpt delve ];

    inherit (opts) globals opts;
    inherit (keymaps) keymaps;

    plugins = barbar.plugins // cmp.plugins // common.plugins // lsp.plugins
      // neoTree.plugins // telescope.plugins // treesitter.plugins
      // whichKey.plugins;

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

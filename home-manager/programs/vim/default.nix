{ inputs, pkgs, user, ... }:

{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = let
    lib = pkgs.lib;
    opts = import ./opts.nix;

    pluginPaths = [
      ./plugins/barbar.nix
      ./plugins/cmp.nix
      ./plugins/conform.nix
      ./plugins/copilot.nix
      ./plugins/dap.nix
      ./plugins/fidget.nix
      ./plugins/flash.nix
      ./plugins/floaterm.nix
      ./plugins/friendly-snippets.nix
      ./plugins/gitsigns.nix
      # ./plugins/gp.nix
      ./plugins/illuminate.nix
      ./plugins/indent-blankline.nix
      ./plugins/lint.nix
      ./plugins/lsp.nix
      ./plugins/mini.nix
      ./plugins/neo-tree.nix
      ./plugins/neoclip.nix
      ./plugins/neotest.nix
      ./plugins/nix.nix
      ./plugins/noice.nix
      ./plugins/notify.nix
      ./plugins/nvim-autopairs.nix
      ./plugins/telescope.nix
      ./plugins/todo-comments.nix
      ./plugins/transparent.nix
      ./plugins/treesitter.nix
      ./plugins/ts.nix
      ./plugins/twillight.nix
      ./plugins/undo-tree.nix
      ./plugins/web-devicons.nix
      ./plugins/which-key.nix
      ./plugins/yanky.nix
    ];

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

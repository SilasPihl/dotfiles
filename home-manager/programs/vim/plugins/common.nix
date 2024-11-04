{ pkgs, ... }:

{
  plugins = {
    cmp-buffer.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-path.enable = true;
    cmp_luasnip.enable = true;
    conform-nvim.enable = true;
    copilot-vim.enable = true;
    flash.enable = true;
    floaterm = {
      enable = true;
      width = 0.8;
      height = 0.8;
      keymaps.toggle = "<leader>t";
    };
    friendly-snippets.enable = true;
    gitsigns.enable = true;
    illuminate.enable = true;
    indent-blankline.enable = true;
    lazy.enable = true;
    lazygit = {
      enable = true;
      settings = {
        config_file_path = "/Users/${user}/dotfiles/themes/lazygit/theme.yml";
        use_custom_config_file_path = 1;
      };
    };
    lint.enable = true;
    lsp-format = {
      enable = true;
      lspServersToEnable = "all";
    };
    none-ls = {
      enable = true;
      enableLspFormat = true;
      sources.formatting.nixfmt.enable = true;
      sources.formatting.gofumpt.enable = true;
    };
    neoclip.enable = true;
    neotest = {
      enable = true;
      adapters.go = {
        enable = true;
        settings = { testFlags = [ "-tags=unit,integration" ]; };
      };
    };
    nix-develop.enable = true;
    nix.enable = true;
    noice.enable = true;
    notify.enable = true;
    nvim-autopairs.enable = true;
    mini.enable = true;
    tmux-navigator.enable = true;
    transparent.enable = true;
    treesitter-context.enable = true;
    treesitter-textobjects.enable = true;
    todo-comments.enable = true;
    ts-autotag.enable = true;
    ts-context-commentstring.enable = true;
    twilight.enable = true;
    yanky = {
      enable = true;
      enableTelescope = true;
    };
    web-devicons.enable = true;
  };
}

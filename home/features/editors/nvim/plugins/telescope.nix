{ pkgs, ... }:

{
  plugins.telescope = {
    enable = true;
    extensions = {
      manix.enable = true;
      media-files = {
        enable = true;
        settings = { cword = true; };
      };
      undo.enable = true;
    };

    settings = {
      pickers = {
        find_files = {
          hidden = true;
          file_ignore_patterns = [ "%.git/" "^node_modules/" "^.venv/" ];
        };
        live_grep = {
          additional_args = { __raw = "function() return { '--hidden' } end"; };
        };
      };
    };

    keymaps = {
      "<leader>/" = {
        action = "live_grep";
        options = { desc = "Grep"; };
      };
      "<leader>p" = {
        action = "find_files";
        options = { desc = "Find files"; };
      };
      "<leader>b" = {
        action = "buffers";
        options = { desc = "Buffers"; };
      };
      "<leader>k" = {
        action = "keymaps";
        options = { desc = "Telescope Keymaps"; };
      };
      "gd" = {
        action = "lsp_definitions";
        options = { desc = "LSP Definitions"; };
      };
      "gr" = {
        action = "lsp_references";
        options = { desc = "LSP References"; };
      };
    };
  };
}

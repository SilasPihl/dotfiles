{ pkgs, ... }:

{
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>/" = {
        action = "live_grep";
        options = { desc = "Telescope Live Grep"; };
      };
      "<leader>p" = {
        action = "find_files";
        options = { desc = "Telescope Find Files"; };
      };
      "<leader>b" = {
        action = "buffers";
        options = { desc = "Telescope Buffers"; };
      };
      "<leader>k" = {
        action = "keymaps";
        options = { desc = "Telescope Keymaps"; };
      };
      "gd" = {
        action = "lsp_definitions";
        options = { desc = "Telescope LSP Definitions"; };
      };
      "gr" = {
        action = "lsp_references";
        options = { desc = "Telescope LSP References"; };
      };
    };
  };
}

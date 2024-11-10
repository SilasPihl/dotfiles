{ pkgs, ... }:

{
  plugins.twilight.enable = true;

  keymaps = [{
    mode = "n";
    key = "<leader>z";
    action = "<cmd>Twilight<CR>";
    options.desc = "Twilight";
  }];
}

{ pkgs, ... }:

{
  plugins.twilight = {
    enable = true;
    settings = {
      context = 20;
      dimming = {
        alpha = 0.5;
      };
    };
  };

  keymaps = [{
    mode = "n";
    key = "<leader>z";
    action = "<cmd>Twilight<CR>";
    options.desc = "Twilight";
  }];
}

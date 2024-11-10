{ pkgs, ... }:

{
  plugins.floaterm = {
    enable = true;
    width = 0.8;
    height = 0.8;
    shell = "${pkgs.zsh}/bin/zsh";
    autoinsert = true;
  };

  keymaps = [{
    mode = "n";
    key = "<leader>t";
    action = ":FloatermToggle<CR>";
    options.desc = "Terminal";
  }];

}

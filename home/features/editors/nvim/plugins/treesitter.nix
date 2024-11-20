{ pkgs, ... }:

{
  plugins.treesitter = {
    enable = true;
    settings = {
      auto_install = true;
      highlight = { enable = true; };
    };
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      go
      gomod
      gosum
      gowork
      json
      lua
      make
      markdown
      nix
      regex
      toml
      vim
      vimdoc
      xml
      yaml
    ];
  };

  plugins.treesitter-context = {
    enable = false;
    settings = {
      line_numbers = true;
      max_lines = 0;
      min_window_height = 0;
      mode = "topline";
      multiline_threshold = 20;
      separator = "-";
      trim_scope = "inner";
      zindex = 20;
    };
  };
  plugins.treesitter-textobjects.enable = true;
}

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

  plugins.treesitter-context.enable = false;
  plugins.treesitter-textobjects.enable = true;
}

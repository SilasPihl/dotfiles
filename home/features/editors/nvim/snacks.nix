{ pkgs, user, ... }: {

  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "snacks";
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "snacks.nvim";
          rev = "974bccb126b6b5d7170c519c380207069d23f557";
          hash = "sha256-h7nysvfJDuNUyu+qrg4HmwyPxYiVq+Fmx8zqmWuV/EI=";
        };
      })
    ];

    extraConfigLua = ''
      require("snacks").setup({
        bigfile = { enabled = true },
        bufdelete = { enabled = true },
        dashboard = { enabled = true },
        debug = { enabled = true },
        git = { enabled = true },
        lazygit = { enabled = true },
        notifier = { 
          enabled = true,
          timeout = 2500,
        },
        rename = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        terminal = { enabled = true },
        toggle = { enabled = true },
        words = { enabled = true },
      });
    '';
  };
}

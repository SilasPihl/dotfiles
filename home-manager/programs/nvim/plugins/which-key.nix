{ pkgs, ... }:

{
  plugins.which-key = {
    enable = true;
    settings = {
      delay = 200;
      expand = 1;
      notify = false;
      preset = false;
      replace = {
        desc = [
          [ "<space>" "SPACE" ]
          [ "<leader>" "SPACE" ]
          [ "<[cC][rR]>" "RETURN" ]
          [ "<[tT][aA][bB]>" "TAB" ]
          [ "<[bB][sS]>" "BACKSPACE" ]
        ];
      };
      spec = [
        {
          __unkeyed-1 = "<leader>b";
          group = "Buffers";
          icon = "󰓩 ";
        }
        {
          __unkeyed = "<leader>c";
          group = "Codesnap";
          icon = "󰄄 ";
          mode = "v";
        }
        {
          __unkeyed-1 = "<leader>bs";
          group = "Sort";
          icon = "󰒺 ";
        }
        {
          __unkeyed-1 = "<leader>t";
          group = "Terminal";
        }
        {
          __unkeyed-1 = "<leader>e";
          group = "Neo-tree";
        }
        {
          __unkeyed-1 = "<leader>z";
          group = "Twilight";
        }
        {
          __unkeyed-1 = "<leader>T";
          group = "Test";
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "Debug";
        }
        {
          __unkeyed-1 = "<leader>w";
          group = "windows";
          proxy = "<C-w>";
        }
      ];
      win = { border = "single"; };
    };
  };
}

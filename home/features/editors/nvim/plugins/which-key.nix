{ pkgs, ... }: {
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
        # Existing key mappings
        {
          __unkeyed-1 = "<leader>b";
          group = "Buffer";
          icon = "󰓩 ";
        }
        {
          __unkeyed-1 = "<leader>e";
          group = "Neo-tree";
        }
        {
          __unkeyed-1 = "<leader>k";
          desc = "Telescope Keymaps";
          cmd = "<cmd>Telescope keymaps<CR>";
        }
        {
          __unkeyed-1 = "gd";
          desc = "Telescope LSP Definitions";
          cnd = "<cmd>Telescope lsp_definitions<CR>";
        }
        {
          __unkeyed-1 = "gr";
          desc = "Telescope LSP References";
          cmd = "<cmd>Telescope lsp_references<CR>";
        }
        {
          __unkeyed-1 = "<leader>z";
          desc = "Zen Mode";
          cmd = "<cmd>ZenMode<CR>";
        }
        {
          __unkeyed-1 = "<leader>w";
          group = "Windows";
          proxy = "<C-w>";
        }
        {
          __unkeyed-1 = "<C-g>t";
          desc = "Copilot Chat Toggle";
          cmd = "<cmd>CopilotChatToggle<CR>";
        }
        {
          __unkeyed-1 = "<C-g>e";
          desc = "Copilot Chat Explain";
          cmd = "<cmd>CopilotChatExplain<CR>";
          mode = "v";
        }
        {
          __unkeyed-1 = "<C-g>r";
          desc = "Copilot Chat Review";
          cmd = "<cmd>CopilotChatReview<CR>";
          mode = "v";
        }
        {
          __unkeyed-1 = "<C-g>f";
          desc = "Copilot Chat Fix";
          cmd = "<cmd>CopilotChatFix<CR>";
          mode = "v";
        }
        {
          __unkeyed-1 = "<C-g>d";
          desc = "Copilot Chat Docs";
          cmd = "<cmd>CopilotChatDocs<CR>";
          mode = "v";
        }
        {
          __unkeyed-1 = "<C-g>fd";
          desc = "Copilot Chat Fix Diagnostic";
          cmd = "<cmd>CopilotChatFixDiagnostic<CR>";
          mode = "v";
        }
        {
          __unkeyed-1 = "<C-g>cs";
          desc = "Copilot Chat Commit Staged";
          cmd = "<cmd>CopilotChatCommitStaged<CR>";
        }
        {
          __unkeyed-1 = "<C-g>a";
          desc = "Copilot Chat Accept";
          cmd = "<cmd>CopilotChatAccept<CR>";
        }
        # {
        #   __unkeyed-1 = "<leader>gc";
        #   desc = "New Chat";
        #   cmd = "<cmd>GpChatNew<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gv";
        #   desc = "Chat New VSplit";
        #   cmd = "<cmd>GpChatNew vsplit<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gs";
        #   desc = "Chat New Split";
        #   cmd = "<cmd>GpChatNew split<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gt";
        #   desc = "Chat New Tab";
        #   cmd = "<cmd>GpChatNew tabnew<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gP";
        #   desc = "Chat Paste";
        #   cmd = "<cmd>GpChatPaste<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gF";
        #   desc = "Chat Finder";
        #   cmd = "<cmd>GpChatFinder<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gd";
        #   desc = "Chat Delete";
        #   cmd = "<cmd>GpChatDelete<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gr";
        #   desc = "Rewrite";
        #   cmd = "<cmd>GpRewrite<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>ga";
        #   desc = "Append";
        #   cmd = "<cmd>GpAppend<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gb";
        #   desc = "Prepend";
        #   cmd = "<cmd>GpPrepend<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>ge";
        #   desc = "Enew";
        #   cmd = "<cmd>GpEnew<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gn";
        #   desc = "New Horizontal";
        #   cmd = "<cmd>GpNew<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gvn";
        #   desc = "Vnew";
        #   cmd = "<cmd>GpVnew<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gtb";
        #   desc = "Tabnew";
        #   cmd = "<cmd>GpTabnew<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gp";
        #   desc = "Popup";
        #   cmd = "<cmd>GpPopup<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gi";
        #   desc = "Implement";
        #   cmd = "<cmd>GpImplement<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gx";
        #   desc = "Toggle Context";
        #   cmd = "<cmd>GpContext<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gvc";
        #   desc = "Context VSplit";
        #   cmd = "<cmd>GpContext vsplit<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gsc";
        #   desc = "Context Split";
        #   cmd = "<cmd>GpContext split<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gtc";
        #   desc = "Context Tab";
        #   cmd = "<cmd>GpContext tabnew<CR>";
        # }
        # {
        #   __unkeyed-1 = "<leader>gpc";
        #   desc = "Context Popup";
        #   cmd = "<cmd>GpContext popup<CR>";
        # }
      ];
      win = { border = "single"; };
    };
  };
}

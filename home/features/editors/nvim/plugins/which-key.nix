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
        # Individual key mappings
        {
          __unkeyed-1 = "<leader>b";
          group = "Buffer";
          icon = "󰓩 ";
        }
        {
          __unkeyed-1 = "<leader>e";
          desc = "Neotree toggle";
          cmd = "<cmd>Neotree toggle<CR>";
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
          __unkeyed-1 = "<leader>u";
          desc = "Undotree";
          cmd = "<cmd>UndotreeToggle<CR>";
        }

        # Telescope
        {
          __unkeyed-1 = "<leader>k";
          desc = "Telescope Keymaps";
          cmd = "<cmd>Telescope keymaps<CR>";
        }
        {
          __unkeyed-1 = "gd";
          desc = "Telescope LSP Definitions";
          cmd = "<cmd>Telescope lsp_definitions<CR>";
        }
        {
          __unkeyed-1 = "gr";
          desc = "Telescope LSP References";
          cmd = "<cmd>Telescope lsp_references<CR>";
        }

        # CopilotChat
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

        # Neotest key mappings
        {
          mode = "n";
          key = "<leader>Tf";
          action =
            "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>";
          options.desc = "Test file";
        }
        {
          mode = "n";
          key = "<leader>Td";
          action =
            "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<CR>";
          options.desc = "Test file with debugger";
        }
        {
          mode = "n";
          key = "<leader>Tn";
          action = "<cmd>lua require('neotest').run.run()<CR>";
          options.desc = "Test nearest";
        }
        {
          mode = "n";
          key = "<leader>Tl";
          action = "<cmd>lua require('neotest').run.run_last()<CR>";
          options.desc = "Test last";
        }
        {
          mode = "n";
          key = "<leader>Tw";
          action =
            "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<CR>";
          options.desc = "Watch file";
        }
        {
          mode = "n";
          key = "<leader>Ts";
          action = "<cmd>lua require('neotest').summary.toggle()<CR>";
          options.desc = "Summary toggle";
        }

        # Dap
        {
          __unkeyed-1 = "<leader>dt";
          desc = "dap ui toggle";
          cmd = ":dapuitoggle<cr>";
        }
        {
          __unkeyed-1 = "<leader>db";
          desc = "dap toggle breakpoint";
          cmd = ":daptogglebreakpoint<cr>";
        }
        {
          __unkeyed-1 = "<leader>dc";
          desc = "dap continue";
          cmd = ":dapcontinue<cr>";
        }
        {
          __unkeyed-1 = "<leader>dr";
          desc = "dap restart";
          cmd = ":lua require('dapui').open({reset=true})<cr>";
        }
      ];
      win = { border = "single"; };
    };
  };
}

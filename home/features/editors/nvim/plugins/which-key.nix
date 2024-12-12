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
          __unkeyed-1 = "<C-g>f";
          desc = "Copilot Chat Fix";
          cmd = "<cmd>CopilotChatFix<CR>";
          mode = "v";
        }
        {
          __unkeyed-1 = "<C-g>fd";
          desc = "Copilot Chat Fix Diagnostic";
          cmd = "<cmd>CopilotChatFixDiagnostic<CR>";
          mode = "v";
        }
        # Gp Commands under <C-g>
        {
          __unkeyed-1 = "<C-g>";
          group = "Gp Commands";
        }
        # {
        #   __unkeyed-1 = "<C-g>t";
        #   desc = "ChatToggle";
        #   cmd = "<cmd>GpChatToggle<cr>";
        # }
        {
          __unkeyed-1 = "<C-g>v";
          desc = "ChatNew vsplit";
          cmd = "<cmd>GpChatNew vsplit<cr>";
        }
        {
          __unkeyed-1 = "<C-g>c";
          desc = "New Chat";
          cmd = "<cmd>GpChatNew<cr>";
        }
        {
          __unkeyed-1 = "<C-g>n";
          desc = "Next Agent";
          cmd = "<cmd>GpNextAgent<cr>";
        }
        {
          __unkeyed-1 = "<C-g>a";
          desc = "Append (after)";
          cmd = ":<C-u>'<,'>GpAppend<cr>";
        }
        {
          __unkeyed-1 = "<C-g>b";
          desc = "Prepend (before)";
          cmd = ":<C-u>'<,'>GpPrepend<cr>";
        }
        {
          __unkeyed-1 = "<C-g>p";
          desc = "Chat Paste";
          cmd = ":<C-u>'<,'>GpChatPaste<cr>";
        }
        {
          __unkeyed-1 = "<C-g>r";
          desc = "Rewrite";
          cmd = ":<C-u>'<,'>GpRewrite<cr>";
        }
        {
          __unkeyed-1 = "<C-g>i";
          desc = "Implement selection";
          cmd = ":<C-u>'<,'>GpImplement<cr>";
        }

        # Neotest key mappings
        {
          __unkeyed-1 = "<leader>T";
          group = "Tests";
        }
        {
          __unkeyed-1 = "<leader>Tf";
          desc = "Test file";
          cmd = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>";
        }
        {
          __unkeyed-1 = "<leader>Td";
          desc = "Test file with debugger";
          cmd =
            "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<CR>";
        }
        {
          __unkeyed-1 = "<leader>Tn";
          desc = "Test nearest";
          cmd = "<cmd>lua require('neotest').run.run()<CR>";
        }
        {
          __unkeyed-1 = "<leader>Tl";
          desc = "Test last";
          cmd = "<cmd>lua require('neotest').run.run_last()<CR>";
        }
        {
          __unkeyed-1 = "<leader>Tw";
          desc = "Watch file";
          cmd =
            "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<CR>";
        }
        {
          __unkeyed-1 = "<leader>Ts";
          desc = "Summary toggle";
          cmd = "<cmd>lua require('neotest').summary.toggle()<CR>";
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

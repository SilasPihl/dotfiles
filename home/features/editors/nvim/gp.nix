{ pkgs, user, ... }: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "gp";
        src = pkgs.fetchFromGitHub {
          owner = "Robitx";
          repo = "gp.nvim";
          rev = "2372d5323c6feaa2e9c19f7ccb537c615d878e18";
          hash = "sha256-QUZrFU/+TPBEU8yi9gmyRYjI/u7DP88AxcS0RMk7Jvk=";
        };
      })
    ];

    extraConfigLua = ''
      require("gp").setup({
        openai_api_key = os.getenv("OPENAI_API_KEY"),
        providers = {
          anthropic = {
            endpoint = "https://api.anthropic.com/v1/messages",
            secret = os.getenv("ANTHROPIC_API_KEY"),
          },
          copilot = {
            endpoint = "https://api.githubcopilot.com/chat/completions",
            secret = {
              "bash",
              "-c",
              "cat /Users/${user}/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
            },
          },
          ollama = {
            endpoint = "http://localhost:11434/v1/chat/completions",
          },
          openai = {
            endpoint = "https://api.openai.com/v1/chat/completions",
            secret = vim.fn.getenv("OPENAI_API_KEY"),
          },
        },
        agents = {
          {
            name = "Codellama",
            chat = true,
            command = true,
            provider = "ollama",
            model = { model = "codellama" },
            system_prompt = "I am an AI meticulously crafted to provide programming guidance and code assistance. "
              .. "To best serve you as a computer programmer, please provide detailed inquiries and code snippets when necessary, "
              .. "and expect precise, technical responses tailored to your development needs.\n",
          },
          -- {
          --   name = "Claude3Haiku",
          --   chat = true,
          --   command = true,
          --   provider = "anthropic",
          --   model = { model = "claude-3-haiku-20240307" },
          --   system_prompt = "You are a general AI assistant.\n\n"
          --     .. "The user provided the additional info about how they would like you to respond:\n\n"
          --     .. "- If you're unsure don't guess and say you don't know instead.\n"
          --     .. "- Ask question if you need clarification to provide better answer.\n"
          --     .. "- Think deeply and carefully from first principles step by step.\n"
          --     .. "- Zoom out first to see the big picture and then zoom in to details.\n"
          --     .. "- Use Socratic method to improve your thinking and coding skills.\n"
          --     .. "- Don't elide any code from your output if the answer requires coding.\n"
          --     .. "- Take a deep breath; You've got this!\n",
          -- },
        },
        hooks = {
          CodeReview = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
              .. "```{{filetype}}\n{{selection}}\n```\n\n"
              .. "Please analyze for code smells and suggest improvements."
            local agent = gp.get_chat_agent()
            gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
          end,
          BufferChatNew = function(gp, _)
            vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
          end,
        },
      })

      -- Key mappings
      local wk = require("which-key")
      wk.register({
        -- VISUAL mode mappings
        ["v"] = {
          ["<C-g><C-t>"] = { ":<C-u>'<,'>GpChatNew tabnew<cr>", "ChatNew tabnew", icon = "󰗋" },
          ["<C-g><C-v>"] = { ":<C-u>'<,'>GpChatNew vsplit<cr>", "ChatNew vsplit", icon = "󰗋" },
          ["<C-g><C-x>"] = { ":<C-u>'<,'>GpChatNew split<cr>", "ChatNew split", icon = "󰗋" },
          ["<C-g>a"] = { ":<C-u>'<,'>GpAppend<cr>", "Visual Append (after)", icon = "󰗋" },
          ["<C-g>b"] = { ":<C-u>'<,'>GpPrepend<cr>", "Visual Prepend (before)", icon = "󰗋" },
          ["<C-g>c"] = { ":<C-u>'<,'>GpChatNew<cr>", "Visual Chat New", icon = "󰗋" },
          ["<C-g>g"] = { name = "generate into new ..", icon = "󰗋" },
          ["<C-g>ge"] = { ":<C-u>'<,'>GpEnew<cr>", "Visual GpEnew", icon = "󰗋" },
          ["<C-g>gn"] = { ":<C-u>'<,'>GpNew<cr>", "Visual GpNew", icon = "󰗋" },
          ["<C-g>gp"] = { ":<C-u>'<,'>GpPopup<cr>", "Visual Popup", icon = "󰗋" },
          ["<C-g>gt"] = { ":<C-u>'<,'>GpTabnew<cr>", "Visual GpTabnew", icon = "󰗋" },
          ["<C-g>gv"] = { ":<C-u>'<,'>GpVnew<cr>", "Visual GpVnew", icon = "󰗋" },
          ["<C-g>i"] = { ":<C-u>'<,'>GpImplement<cr>", "Implement selection", icon = "󰗋" },
          ["<C-g>n"] = { "<cmd>GpNextAgent<cr>", "Next Agent", icon = "󰗋" },
          ["<C-g>p"] = { ":<C-u>'<,'>GpChatPaste<cr>", "Visual Chat Paste", icon = "󰗋" },
          ["<C-g>r"] = { ":<C-u>'<,'>GpRewrite<cr>", "Visual Rewrite", icon = "󰗋" },
          ["<C-g>s"] = { "<cmd>GpStop<cr>", "GpStop", icon = "󰗋" },
          ["<C-g>t"] = { ":<C-u>'<,'>GpChatToggle<cr>", "Visual Toggle Chat", icon = "󰗋" },
          ["<C-g>x"] = { ":<C-u>'<,'>GpContext<cr>", "Visual GpContext", icon = "󰗋" },
        },

        -- NORMAL mode mappings
        ["n"] = {
          ["<C-g><C-t>"] = { "<cmd>GpChatNew tabnew<cr>", "New Chat tabnew" },
          ["<C-g><C-v>"] = { "<cmd>GpChatNew vsplit<cr>", "New Chat vsplit" },
          ["<C-g><C-x>"] = { "<cmd>GpChatNew split<cr>", "New Chat split" },
          ["<C-g>a"] = { "<cmd>GpAppend<cr>", "Append (after)" },
          ["<C-g>b"] = { "<cmd>GpPrepend<cr>", "Prepend (before)" },
          ["<C-g>c"] = { "<cmd>GpChatNew<cr>", "New Chat" },
          ["<C-g>f"] = { "<cmd>GpChatFinder<cr>", "Chat Finder" },
          ["<C-g>g"] = { name = "generate into new .." },
          ["<C-g>ge"] = { "<cmd>GpEnew<cr>", "GpEnew" },
          ["<C-g>gn"] = { "<cmd>GpNew<cr>", "GpNew" },
          ["<C-g>gp"] = { "<cmd>GpPopup<cr>", "Popup" },
          ["<C-g>gt"] = { "<cmd>GpTabnew<cr>", "GpTabnew" },
          ["<C-g>gv"] = { "<cmd>GpVnew<cr>", "GpVnew" },
          ["<C-g>n"] = { "<cmd>GpNextAgent<cr>", "Next Agent" },
          ["<C-g>r"] = { "<cmd>GpRewrite<cr>", "Inline Rewrite" },
          ["<C-g>s"] = { "<cmd>GpStop<cr>", "GpStop" },
          ["<C-g>t"] = { "<cmd>GpChatToggle<cr>", "Toggle Chat" },
          ["<C-g>x"] = { "<cmd>GpContext<cr>", "Toggle GpContext" },
        },

        -- INSERT mode mappings
        ["i"] = {
          ["<C-g><C-t>"] = { "<cmd>GpChatNew tabnew<cr>", "New Chat tabnew" },
          ["<C-g><C-v>"] = { "<cmd>GpChatNew vsplit<cr>", "New Chat vsplit" },
          ["<C-g><C-x>"] = { "<cmd>GpChatNew split<cr>", "New Chat split" },
          ["<C-g>a"] = { "<cmd>GpAppend<cr>", "Append (after)" },
          ["<C-g>b"] = { "<cmd>GpPrepend<cr>", "Prepend (before)" },
          ["<C-g>c"] = { "<cmd>GpChatNew<cr>", "New Chat" },
          ["<C-g>f"] = { "<cmd>GpChatFinder<cr>", "Chat Finder" },
          ["<C-g>g"] = { name = "generate into new .." },
          ["<C-g>ge"] = { "<cmd>GpEnew<cr>", "GpEnew" },
          ["<C-g>gn"] = { "<cmd>GpNew<cr>", "GpNew" },
          ["<C-g>gp"] = { "<cmd>GpPopup<cr>", "Popup" },
          ["<C-g>gt"] = { "<cmd>GpTabnew<cr>", "GpTabnew" },
          ["<C-g>gv"] = { "<cmd>GpVnew<cr>", "GpVnew" },
          ["<C-g>n"] = { "<cmd>GpNextAgent<cr>", "Next Agent" },
          ["<C-g>r"] = { "<cmd>GpRewrite<cr>", "Inline Rewrite" },
          ["<C-g>s"] = { "<cmd>GpStop<cr>", "GpStop" },
          ["<C-g>t"] = { "<cmd>GpChatToggle<cr>", "Toggle Chat" },
          ["<C-g>x"] = { "<cmd>GpContext<cr>", "Toggle GpContext" },
        },
      })
    '';
  };
}

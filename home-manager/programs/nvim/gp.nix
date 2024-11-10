{ pkgs, ... }: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "gp";
        src = pkgs.fetchFromGitHub {
          owner = "Robitx";
          repo = "gp.nvim";
          rev = "2372d5323c6feaa2e9c19f7ccb537c615d878e18";
          hash = "sha256-nowrrgdRxxJ81xsmuUYKsbPNLTGVKO6KbSpU0U98lWE=";
        };
      })
    ];

    extraConfigLua = ''
      require("gp").setup({
        openai_api_key = "sk-1234567890abcdef1234567890abcdef";
        providers = {
          ollama = {
            endpoint = "http://localhost:11434/v1/chat/completions",
          },
          openai = {
            disable = false, 
          },
          azure = {},
          copilot = {},
          lmstudio = {},
          googleai = {},
          pplx = {},
          anthropic = {},
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
        },
        toggle_target = "vsplit",
      })
    '';

    keymaps = [
      {
        key = "<leader>ac";
        action = "<cmd>GpChatToggle vsplit<cr>";
        options = { desc = "ChatGPT"; };
      }

      {
        key = "<leader>au";
        action = "<cmd>GpChatStop<cr>";
        options = { desc = "ChatGPT Stop"; };
      }

      {
        key = "<leader>an";
        action = "<cmd>GpChatNew<cr>";
        options = { desc = "ChatGPT New Chat"; };
      }

      {
        key = "<leader>ad";
        action = "<cmd>GpChatDelete<cr>";
        options = { desc = "ChatGPT Delete Chat"; };
      }

      {
        key = "<leader>aa";
        action = "<cmd>GpChatRespond<cr>";
        options = { desc = "ChatGPT Send Message"; };
      }

      {
        key = "<leader>af";
        action = "<cmd>GpChatFinder<cr>";
        options = { desc = "ChatGPT Find Chat"; };
      }

      {
        mode = "v";
        key = "<leader>ap";
        action = "<cmd>GpChatPaste<cr>";
        options = { desc = "ChatGPT Paste Selection to Chat"; };
      }
    ];
  };
}

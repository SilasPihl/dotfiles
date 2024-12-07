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
        providers = {
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
        },
        default_command_agent = "Qwen2.5Coder",
        default_chat_agent = "Qwen2.5Coder",
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
          {
            name = "Qwen2.5Coder",
            chat = true,
            command = true,
            provider = "ollama",
            model = { model = "qwen2.5-coder:1.5b" },
            system_prompt = "You are a general AI assistant.\n\n"
              .. "The user provided the additional info about how they would like you to respond:\n\n"
              .. "- If you're unsure don't guess and say you don't know instead.\n"
              .. "- Ask question if you need clarification to provide better answer.\n"
              .. "- Think deeply and carefully from first principles step by step.\n"
              .. "- Zoom out first to see the big picture and then zoom in to details.\n"
              .. "- Use Socratic method to improve your thinking and coding skills.\n"
              .. "- Don't elide any code from your output if the answer requires coding.\n"
              .. "- Take a deep breath; You've got this!\n",
          },
        },
        hooks = {
          CodeReview = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
              .. "```{{filetype}}\n{{selection}}\n```\n\n"
              .. "Please analyze for code smells and suggest improvements."
            local agent = gp.get_chat_agent()
            gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
          end,
          BufferChatNew = function(gp, _)gp.
            vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
          end,
          Explain = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
              .. "```{{filetype}}\n{{selection}}\n```\n\n"
              .. "Please respond by explaining the code above."
            local agent = gp.get_chat_agent()
            gp.Prompt(params, gp.Target.popup, agent, template)
          end,
          UnitTests = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
              .. "```{{filetype}}\n{{selection}}\n```\n\n"
              .. "Please respond by writing table driven unit tests for the code above."
            local agent = gp.get_command_agent()
            gp.Prompt(params, gp.Target.vnew, agent, template)
          end,
        },
      })
    '';
  };
}

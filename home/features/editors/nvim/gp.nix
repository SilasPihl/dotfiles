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
        openai_api_key = "sk-1234567890abcdef1234567890abcdef",
        providers = {
          ollama = {
            endpoint = "http://localhost:11434/v1/chat/completions",
          },
          copilot = {
            endpoint = "https://api.githubcopilot.com/chat/completions",
            secret = {
              "bash",
              "-c",
              "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
            },
          },
        },
        whisper = {
          disable = true;
        }
        agents = {
          { 
            provider = "copilot", 
            name = "CodeCopilot", 
            chat = false, 
            command = true, 
            model = { model = "gpt-4o", temperature = 0.8, top_p = 1, n = 1 }, 
            system_prompt = "You are a helpful coding assistant, optimized to provide code responses directly.\n"
          }, 
        },
        toggle_target = "vsplit",
      })
    '';
  };
}

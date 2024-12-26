return {
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = false, -- Set to false to integrate with blink-cmp
        },
        suggestion = {
          enabled = false, -- Set to false to integrate with blink-cmp
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = "node", -- Node.js version must be > 18.x
        server_opts_overrides = {},
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },

    opts = {
      settings = {
        auto_insert_mode = true,
        temperature = 0.0,
        window = {
          layout = "float",
          width = 0.75,
          height = 0.75,
        },
        question_header = "## Sebastian",
        defaults = {
          Commit = {
            prompt =
            "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
            selection = "require('CopilotChat.select').gitdiff",
          },
          CommitStaged = {
            prompt =
            "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
            selection = function(source)
              return require("CopilotChat.select").gitdiff(source, true)
            end,
          },
          Docs = {
            prompt = "Please add documentation comment for the selection.",
          },
          Explain = {
            prompt = "Write an explanation for the active selection as paragraphs of text.",
          },
          Fix = {
            prompt = "There is a problem in this code. Rewrite the code to show it with the bug fixed.",
          },
          FixDiagnostic = {
            prompt = "Please assist with the following diagnostic issue in file:",
            selection = "require('CopilotChat.select').diagnostics",
          },
          Optimize = {
            prompt = "Optimize the selected code to improve performance and readability.",
          },
          Review = {
            prompt = "Review the selected code.",
            callback = function(response, source)
              -- See implementation in config.lua
            end,
          },
          Tests = {
            prompt = "Please generate tests for my code.",
          },
        },
      },
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)

      -- Add keymap to toggle chat
      vim.keymap.set("n", "<C-c>", function()
        require("CopilotChat").toggle()
      end, { desc = "Toggle Copilot Chat" })

      vim.api.nvim_create_user_command("CopilotChatDebug", function()
        print(vim.inspect(require("CopilotChat").get_settings()))
      end, {})
    end,
  },
}

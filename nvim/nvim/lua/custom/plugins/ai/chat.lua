return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    enabled = false, -- Testing out JackMort/ChatGPT
    opts = {
      auto_insert_mode = true,
      temperature = 0.0,
      window = {
        layout = "vertical",
      },
      show_help = false,
      question_header = "## Sebastian",
      prompts = {
        Explain = {
          prompt = "> /COPILOT_EXPLAIN\n\nWrite an explanation for the selected code as paragraphs of text.",
        },
        Review = {
          prompt = "> /COPILOT_REVIEW\n\nReview the selected code.",
        },
        Fix = {
          prompt = "> /COPILOT_GENERATE\n\nThere is a problem in this code. Rewrite the code to show it with the bug fixed.",
        },
        Optimize = {
          prompt = "> /COPILOT_GENERATE\n\nOptimize the selected code to improve performance and readability.",
        },
        Docs = {
          prompt = "> /COPILOT_GENERATE\n\nPlease add documentation comments to the selected code.",
        },
        Tests = {
          prompt = "> /COPILOT_GENERATE\n\nPlease generate tests for my code.",
        },
        Commit = {
          prompt = "> #git:staged\n\nWrite commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
        },
      },
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)

      -- Keybindings for Copilot Chat commands
      vim.keymap.set("n", "<C-c>", function()
        require("CopilotChat").toggle()
      end, { desc = "Toggle Copilot Chat" })

      vim.keymap.set("v", "<C-c>f", "<cmd>CopilotChatFix<CR>", { desc = "Fix diagnostics" })
      vim.keymap.set("v", "<C-c>e", "<cmd>CopilotChatExplain<CR>", { desc = "Explain selection" })
      vim.keymap.set("v", "<C-c>r", "<cmd>CopilotChatReview<CR>", { desc = "Review selection" })
      vim.keymap.set("v", "<C-c>o", "<cmd>CopilotChatOptimize<CR>", { desc = "Optimize selection" })
      vim.keymap.set("v", "<C-c>d", "<cmd>CopilotChatDocs<CR>", { desc = "Generate docs for selection" })
      vim.keymap.set("v", "<C-c>t", "<cmd>CopilotChatTests<CR>", { desc = "Generate tests for selection" })
      vim.keymap.set("v", "<C-c>q", function()
        vim.cmd('normal! "vy')
        local input = vim.fn.getreg('"')
        if input ~= "" then
          local question = vim.fn.input("Enter your question: ")
          if question ~= "" then
            require("CopilotChat").ask(
              question .. "\n\n" .. input,
              { selection = require("CopilotChat.select").visual }
            )
          end
        end
      end, { desc = "CopilotChat - Quick chat" })

      -- Debug command to inspect settings
      vim.api.nvim_create_user_command("CopilotChatDebug", function()
        print(vim.inspect(require("CopilotChat").get_settings()))
      end, { desc = "Inspect Copilot Chat settings" })
    end,
  },
}
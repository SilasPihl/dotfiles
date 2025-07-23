local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  {
    "codecompanion.nvim",
    enabled = false,  -- Disable CodeCompanion
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      adapters = {
        ollama = "ollama",
        copilot = "copilot",
        opts = {
          allow_insecure = false,
          cache_models_for = 1800,
          proxy = nil,
          show_defaults = true, -- Can be false if you only want to see your configured adapters
        },
      },

      constants = constants,

      strategies = {
        chat = {
          adapter = "ollama",
        },
        inline = {
          adapter = "copilot",
        },
      },

      -- PROMPT LIBRARIES -------------------------------------------------------
      -- This entire section can be removed if you don't need custom prompts/workflows
      -- or don't want to override the defaults initially.
      -- prompt_library = {
      --   -- Add custom prompts here or leave empty/remove
      -- },

      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt ",
          provider = "default",
          opts = {
            show_default_actions = true,
            show_default_prompt_library = true,
          },
        },
        chat = {
          icons = { pinned_buffer = " ", watched_buffer = "👀 " },
          debug_window = { width = vim.o.columns - 5, height = vim.o.lines - 2 },
          window = {
            layout = "vertical",
            position = nil,
            border = "single",
            height = 0.8,
            width = 0.80,
            relative = "editor",
            full_height = true,
            opts = {
              breakindent = true,
              cursorcolumn = false,
              cursorline = false,
              foldcolumn = "0",
              linebreak = true,
              list = false,
              numberwidth = 1,
              signcolumn = "no",
              spell = false,
              wrap = true,
            },
          },
          auto_scroll = true,
          intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
          show_header_separator = false,
          separator = "─",
          show_references = true,
          show_settings = false,
          show_token_count = true,
          start_in_insert_mode = false,
          token_count = function(tokens, adapter)
            return " (" .. tokens .. " tokens)"
          end,
        },
        diff = {
          enabled = true,
          close_chat_at = 240,
          layout = "vertical",
          opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
          provider = "default",
        },
        inline = {
          layout = "vertical",
        },
      },

      opts = {
        log_level = "ERROR",
        language = "English",
        send_code = true, -- Can be a boolean or a function returning a boolean
        job_start_delay = 1500, -- Delay between cmd tool executions
        submit_delay = 2000, -- Delay before auto-submitting chat buffer (if enabled elsewhere)
        system_prompt = function(opts)
          local language = opts.language or "English"
          return string.format(
            [[You are an AI programming assistant named "CodeCompanion". You are currently plugged into the Neovim text editor. Keep responses concise and use Markdown formatting. Include the programming language name in code blocks. Respond in %s.]],
            language
            -- NOTE: This is a significantly shortened version of the default prompt.
            -- You might want to keep the original detailed default system prompt
            -- or provide your own more specific instructions.
          )
        end,
      },
    },
    keys = {
      {
        "<C-c>",
        "<cmd>CodeCompanionChat<CR>", -- Command to open/focus the chat window
        mode = "n", -- Normal mode
        noremap = true, -- Recommended for commands
        silent = true, -- Prevent command from echoing
        desc = "CodeCompanion: Toggle Chat", -- Description for which-key etc.
      },
      -- Add other global keymaps related to codecompanion if needed
    },
  },
}

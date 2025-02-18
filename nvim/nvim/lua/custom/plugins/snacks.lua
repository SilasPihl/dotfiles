return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {

      dashboard = {
        enabled = true,
        preset = {
          keys = {

            {
              icon = " ",
              key = "f",
              desc = "Find file",
              action = function()
                Snacks.picker.files()
              end,
            },

            {
              icon = " ",
              key = "/",
              desc = "Find text",
              action = function()
                Snacks.picker.lines()
              end,
            },

            {
              icon = "󰙅 ",
              key = "e",
              desc = "File explorer",
              action = "<cmd>Neotree toggle<CR>",
            },

            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = function()
                Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
              end,
            },

            {
              icon = "󰦛 ",
              key = "s",
              desc = "Restore session",
              action = function()
                require("persistence").load()
              end,
            },

            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "y", desc = "Yazi", action = "<cmd>Yazi<CR>" },
            { icon = " ", key = "t", desc = "Terminal", action = "<cmd>ToggleTerminal<CR>" },
            { icon = " ", key = "T", desc = "TimeTracker", action = "<cmd>TimeTracker<CR>" },

            {
              icon = " ",
              key = "g",
              desc = "git",
              action = function()
                Snacks.lazygit()
              end,
            },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },

        sections = {
          { section = "terminal", cmd = "fortune -s | cowsay", hl = "header", padding = 1, indent = 8 },
          { section = "keys", title = "Keymaps", padding = 1 },
          { section = "recent_files", title = "Recent files", padding = 1 },
        },
      },
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      explorer = {
        enabled = false, -- I tend to like neotree a bit more
      },
      indent = { enabled = true },
      input = { enabled = true },

      image = {
        enabled = true,
        doc = {
          inline = vim.g.neovim_mode == "skitty" and true or false,
          float = true,
          max_width = vim.g.neovim_mode == "skitty" and 20 or 60,
          max_height = vim.g.neovim_mode == "skitty" and 10 or 30,
        },
      },

      notifier = { enabled = true, timeout = 3000 },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },

      picker = {
        enabled = true,
        layout = "ivy",
        matcher = {
          frecency = true,
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["J"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["K"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["H"] = { "preview_scroll_left", mode = { "i", "n" } },
              ["L"] = { "preview_scroll_right", mode = { "i", "n" } },
              ["<Tab>"] = { "list_down", mode = { "i", "n" } },
              ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
            },
          },
        },
      },

      toggle = {
        enabled = true,
        map = vim.keymap.set,
        which_key = true,
        notify = true,
      },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true },
        },
      },
    },
    keys = {

      -- Files
      {
        "<space>f",
        function()
          Snacks.picker.files({
            finder = "files",
            format = "file",
            show_empty = true,
            supports_live = true,
            hidden = true,
            ignored = false,
          })
        end,
        desc = "Find Files",
      },

      -- Buffers
      {
        "<space>b",
        function()
          Snacks.picker.buffers({
            on_show = function()
              vim.cmd.stopinsert()
            end,
            finder = "buffers",
            format = "buffer",
            hidden = false,
            unloaded = true,
            current = true,
            sort_lastused = true,
            win = {
              input = {
                keys = {
                  ["d"] = "bufdelete",
                },
              },
              list = { keys = { ["d"] = "bufdelete" } },
            },
          })
        end,
        desc = "Buffers",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete buffer",
      },
      {
        "<space>/",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer find",
      },

      -- Grep
      {
        "<space>g",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },

      -- Config
      {
        "<space>c",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find config file",
      },

      -- Recent
      {
        "<space>r",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent",
      },

      -- Dianostic
      {
        "<space>d",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },

      -- Keymaps
      {
        "<space>k",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },

      -- Docs
      {
        "<space>m",
        function()
          Snacks.picker.man()
        end,
        desc = "Man pages",
      },

      -- Quickfix
      {
        "<space>q",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix list",
      },

      -- Icons
      {
        "<space>i",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },

      -- Highlights
      {
        "<space>h",
        function()
          Snacks.picker.highlights({ pattern = "hl_group:^Snacks" })
        end,
        desc = "Highlights",
      },

      -- LSP
      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "Goto Definition",
      },
      {
        "gr",
        function()
          Snacks.picker.lsp_references({
            on_show = function()
              vim.cmd.stopinsert()
            end,
          })
        end,
        nowait = true,
        desc = "References",
      },
      {
        "gI",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "Goto Implementation",
      },
      {
        "gy",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "Goto T[y]pe Definition",
      },
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },

      -- File explorer
      {
        "<leader>e",
        function()
          Snacks.explorer({
            hidden = true,
            ignored = true,
          })
        end,
        desc = "File explorer",
      },

      -- Zen
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Toggle Zen Mode",
      },

      -- Notifications
      {
        "<leader>n",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },

      -- Git
      {
        "<leader>GB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
        mode = { "n", "v" },
      },
      {
        "<leader>Gb",
        function()
          Snacks.git.blame_line()
        end,
        desc = "Git Blame Line",
      },
      {
        "<leader>Gf",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Current File History",
      },
      {
        "<leader>g",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd

          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
        end,
      })
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      options = { "buffers", "curdir", "tabpages", "winsize", "folds" },
    },
  },
  {
    "folke/todo-comments.nvim",
    optional = true,
    keys = {
      {
        "<space>t",
        function()
          Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
        end,
        desc = "Todo/Fix/Fixme",
      },
    },
  },
}
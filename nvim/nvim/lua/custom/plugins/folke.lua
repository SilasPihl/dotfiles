return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          -- Header displayed at the top of the dashboard
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]],
          -- Define key bindings for the dashboard
          -- stylua: ignore
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = function() Snacks.picker.files() end },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = function() Snacks.picker.grep() end },
            { icon = " ", key = "r", desc = "Recent Files", action = function() Snacks.picker.recent() end },
            { icon = " ", key = "c", desc = "Config", action = function() Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')}) end },
            { icon = " ", key = "s", desc = "Restore Session", action = function() require("persistence").load() end },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = "", key = "y", desc = "Yazi", action = "<cmd>Yazi<CR>" },
            { icon = "", key = "t", desc = "TimeTracker", action = "<cmd>TimeTrackerOverview<CR>" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        -- Dashboard sections
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
          { pane = 2, title = " ", padding = 8 }, -- For aligning recent files with find files
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          function()
            local in_git = Snacks.git.get_root() ~= nil

            local cmds = {}

            table.insert(cmds, {
              icon = " ",
              title = "Git Status",
              cmd = "git --no-pager diff --stat -B -M -C",
              height = 10,
            })

            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                pane = 2,
                section = "terminal",
                enabled = in_git,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
              }, cmd)
            end, cmds)
          end,
        },
      },
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      picker = {
        enabled = true,
        layout = "ivy",
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
          files = {
            hidden = true,
            ignored = false,
          },
        },
      },
      toggle = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true },
        },
      },
    },
    -- Key mappings
  -- stylua: ignore
   keys = {
    { "<space>f", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<space>b", function() Snacks.picker.buffers({ focus = "list" }) end, desc = "Buffers" },
    { "<space>g", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<space>c", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<space>r", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<space>/", function() Snacks.picker.lines() end, desc = "Fuzzy in open buffer" },
    { "<space>d", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<space>k", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<space>m", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<space>q", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<space>i", function () Snacks.picker.icons() end, desc = "Icons" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    -- File explorer
    { "<leader>e", function() Snacks.explorer() end, desc  = "File explorer"},
    { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
    { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
  },
    -- Initialization logic
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
          vim.print = _G.dd -- Override print to use snacks for `:=` command

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
  -- stylua: ignore
  keys = {
    { "<space>t", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
  },
  },
}

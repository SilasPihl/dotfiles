return {
  "saghen/blink.cmp",
  version = "v0.*",
  dependencies = {
    {
      "giuxtaposition/blink-cmp-copilot",
    },
  },
  opts = {
    keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-n>"] = { "scroll_documentation_down", "fallback" },
      ["<C-p>"] = { "scroll_documentation_up", "fallback" },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 100,
          async = true,
        },
      },
    },
    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 50,
      },
    },
    signature = {
      enabled = true,
    },
  },
}
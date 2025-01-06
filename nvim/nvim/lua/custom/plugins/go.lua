return {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    require("go").setup({
      disable_defaults = false,
      go = "go",
      goimports = "gopls",
      gofmt = "gopls",
      fillstruct = "gopls",
      max_line_len = 0,
      tag_transform = false,
      tag_options = "json=omitempty",
      gotests_template = "",
      gotests_template_dir = "",
      gotest_case_exact_match = true,
      comment_placeholder = "",
      icons = { breakpoint = "🧘", currentpos = "🏃" },
      verbose = false,
      lsp_semantic_highlights = true,
      lsp_cfg = {
        capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          gopls = {
            buildFlags = { "-tags=unit,integration" },
            gofumpt = true,
            hoverKind = "FullDocumentation",
            linkTarget = "pkg.go.dev",
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = {
              "-.git",
              "-.vscode",
              "-.idea",
              "-.vscode-test",
              "-node_modules",
            },
            semanticTokens = true,
            experimentalPostfixCompletions = true,
            diagnosticsDelay = "500ms",
          },
        },
      },
      lsp_on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      end,
      lsp_keymaps = true,
      lsp_codelens = true,
      null_ls = {
        golangci_lint = {
          method = { "NULL_LS_DIAGNOSTICS_ON_SAVE", "NULL_LS_DIAGNOSTICS_ON_OPEN" },
          severity = vim.diagnostic.severity.INFO,
        },
      },
    })
  end,
  event = { "CmdlineEnter" },
  ft = { "go", "gomod" },
  build = ':lua require("go.install").update_all_sync()',
}

return { -- LSP Configs
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "b0o/SchemaStore.nvim",
    "saghen/blink.cmp",
    { "j-hui/fidget.nvim", opts = {} },
  },
  config = function()
    vim.diagnostic.config({
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "",
          [vim.diagnostic.severity.INFO] = "",
        },
      },
    })

    local capabilities = vim.tbl_deep_extend(
      "force",
      require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
      {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      }
    )

    local servers = {
      pyright = {},
      bicep = {},
      terraformls = {},
      buf_ls = {},
      tflint = {},
      ts_ls = {},
      gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        on_attach = function(client, bufnr)
          -- Autoformat on save
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end

          -- Run go test on save (for current file)
          vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = bufnr,
            callback = function()
              -- To run the full package instead, use: "!go test ./..."
              vim.cmd("!go test " .. vim.fn.expand("%"))
            end,
          })
        end,
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
      jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            format = {
              enable = true,
            },
            workspace = {
              checkThirdParty = false,
            },
            codeLens = {
              enable = true,
            },
            completion = {
              callSnippet = "Replace",
            },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = "Disable",
              semicolon = "Disable",
              arrayIndex = "Disable",
            },
          },
        },
      },
    }

    require("mason").setup()

    require("mason-tool-installer").setup({
      ensure_installed = {
        "pyright",
        "bicep",
        "terraformls",
        "buf_ls",
        "tflint",
        "ts_ls",
        "gopls",
        "jsonls",
        "lua_ls",
      },
    })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = capabilities
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
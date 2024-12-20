return { -- LSP Configs
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "b0o/SchemaStore.nvim",
    "saghen/blink.cmp",
    { "j-hui/fidget.nvim",       opts = {} },
    "jose-elias-alvarez/null-ls.nvim", -- Add null-ls
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

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.client_id)
        if not client then
          return
        end

        local bufnr = args.buf

        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })

    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })

    local servers = {
      pyright = {},
      terraformls = {},
      buf_ls = {},
      tflint = {},
      jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },
      lua_ls = {
        capabilities = capabilities,
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
      ensure_installed = vim.tbl_keys(servers),
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

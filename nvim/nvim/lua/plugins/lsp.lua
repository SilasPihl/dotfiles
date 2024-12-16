return { -- LSP Configs
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    { 'folke/neodev.nvim', opts = {} },
  },
  config = function()
    -- Define the on_attach function
    local on_attach = function(client, bufnr)
      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
      end

      -- Jump to the definition of the word under your cursor.
      map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      -- Find references for the word under your cursor.
      map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      -- Jump to the implementation of the word under your cursor.
      map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      -- Jump to the type of the word under your cursor.
      map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
      -- Fuzzy find all the symbols in your current document.
      map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      -- Fuzzy find all the symbols in your current workspace.
      map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
      -- Rename the variable under your cursor.
      map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
      -- Opens a popup that displays documentation about the word under your cursor
      map('K', vim.lsp.buf.hover, 'Hover Documentation')
      -- Goto Declaration.
      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- Highlight references of the word under your cursor when your cursor rests there for a while.
      if client.server_capabilities.documentHighlightProvider then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = bufnr,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = bufnr,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })
        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event.buf }
          end,
        })
      end

      -- Enable inlay hints if the server supports it
      if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, '[T]oggle Inlay [H]ints')
      end
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Function to apply the workaround
    local function apply_fix(server_name, server_opts)
      if server_name == 'gopls' then
        for _, v in pairs(server_opts) do
          if type(v) == 'table' and v.workspace then
            v.workspace.didChangeWatchedFiles = {
              dynamicRegistration = false,
              relativePatternSupport = false,
            }
          end
        end
      end
    end

    local servers = {
      gopls = {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = require("lspconfig.util").root_pattern("go.work", "go.mod", ".git"),
        settings = {
          gopls = {
            buildFlags = { "-tags=unit,integration" },
            gofumpt = true,
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
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
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
          },
        },
      },
      pyright = {},
      terraformls = {},
      azure_pipelines_ls = {},
      dockerls = {},
      eslint = {},
      tflint = {},
      typos_lsp = {},
      ruff = {},
      delve = {},
      bashls = {},
      tailwindcss = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            diagnostics = {
              globals = {
                'vim',
              },
            },
          },
        },
      },
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu.
    require('mason').setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- Apply the workaround here
          apply_fix(server_name, server)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          server.on_attach = on_attach
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}

return { -- LSP Configs
	'neovim/nvim-lspconfig',
	dependencies = {
		{ 'williamboman/mason.nvim', config = true },
		'williamboman/mason-lspconfig.nvim',
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		"b0o/SchemaStore.nvim",
		'saghen/blink.cmp',
		{ 'j-hui/fidget.nvim', opts = {} },
	},
	config = function()
		-- Global diagnostics settings
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
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
		})

		-- Global capabilities
		local capabilities = vim.tbl_deep_extend(
			"force",
			require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
			{
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			}
		)

		-- Global LSP on_attach callback
		vim.api.nvim_create_autocmd('LspAttach', {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.client_id)
				if not client then return end

				-- Key mappings
				local bufnr = args.buf
				local map = function(keys, func, desc)
					vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
				end

				map('K', vim.lsp.buf.hover, 'Hover Documentation')
				map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

				-- Auto-format on save
				if client.supports_method('textDocument/formatting') then
					vim.api.nvim_create_autocmd('BufWritePre', {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end
			end,
		})

		-- Define LSP servers
		local servers = {
			gopls = {
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				settings = {
					gopls = {
						-- General settings
						buildFlags = { "-tags=unit,integration" },
						gofumpt = true,
						hoverKind = "FullDocumentation",
						linkTarget = "pkg.go.dev",
						analyses = {
							fieldalignment = true,
							nilness = true,
							unusedparams = true,
							unusedwrite = true,
							useany = true,
						},
						-- Code Lens
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
						-- Hints
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
						-- Formatting and completion
						usePlaceholders = true,
						completeUnimported = true,
						staticcheck = true,
						-- Directory filters
						directoryFilters = {
							"-.git",
							"-.vscode",
							"-.idea",
							"-.vscode-test",
							"-node_modules",
						},
						-- Semantic tokens
						semanticTokens = true,
						-- Experimental
						experimentalPostfixCompletions = true,
						experimentalDiagnosticsDelay = "500ms",
						experimentalWorkspaces = { "workspace1", "workspace2" },
					},
				},
			},
			pyright = {},
			terraformls = {},
			azure_pipelines_ls = {},
			dockerls = {},
			buf = {},
			eslint = {},
			tflint = {},
			typos_lsp = {},
			opa = {},
			ruff = {},
			jsonls = {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			},
			bashls = {},
			tailwindcss = {},
			lua_ls = {
				capabilities = capabilities,
				settings = {
					Lua = {
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

		-- Mason setup
		require('mason').setup()
		require('mason-tool-installer').setup {
			ensure_installed = vim.tbl_keys(servers),
		}

		require('mason-lspconfig').setup {
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = capabilities
					require('lspconfig')[server_name].setup(server)
				end,
			},
		}
	end,
}

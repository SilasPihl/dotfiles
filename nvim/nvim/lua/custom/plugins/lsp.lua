return { -- LSP Configs
	'neovim/nvim-lspconfig',
	dependencies = {
		{ 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
		'williamboman/mason-lspconfig.nvim',
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		"b0o/SchemaStore.nvim",
		{ 'j-hui/fidget.nvim',       opts = {} },

	},
	config = function()
		local on_attach = function(client, bufnr)
			local map = function(keys, func, desc)
				vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
			end

			map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
			map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
			map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
			map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
			map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
			map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
			map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
			map('K', vim.lsp.buf.hover, 'Hover Documentation')
			map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

			-- Automatically format the file on save if the server supports it
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					client = vim.lsp.get_client_by_id(args.client_id)
					if not client then return end
					if client.supports_method('textDocument/formatting') then
						vim.api.nvim_create_autocmd('BufWritePre', {
							callback = function()
								vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
							end,
						})
					end
				end,
			})

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
			jsonls = {
				server_capabilities = {
					documentFormattingProvider = false,
				},
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = {
								enable = false,
								url = "",
							},
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				},
			},
			delve = {},
			bashls = {},
			tailwindcss = {},
			ts_ls = {
				root_dir = require("lspconfig").util.root_pattern "package.json",
				single_file = false,
				server_capabilities = {
					documentFormattingProvider = false,
				},
			},
			regal = {},
			lua_ls = {
				server_capabilities = {
					semanticTokensProvider = vim.NIL,
				},
			},
		}

		require('mason').setup()
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

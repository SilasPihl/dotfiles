return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"debugloop/telescope-undo.nvim",
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
			"mickael-menu/zk-nvim",
      "gbprod/yanky.nvim",
		},
		opts = {
			defaults = {
				scroll_strategy = "limit",
				path_display = {
					filename_first = {
						reverse_directories = true,
					},
				},
				mappings = {
					n = {
						["d"] = require("telescope.actions").delete_buffer,
						["q"] = require("telescope.actions").close,
						["J"] = require("telescope.actions").preview_scrolling_down,
						["K"] = require("telescope.actions").preview_scrolling_up,
						["H"] = require("telescope.actions").preview_scrolling_left,
						["L"] = require("telescope.actions").preview_scrolling_right,
					},
					i = {
						["<esc>"] = require("telescope.actions").close,
						["J"] = require("telescope.actions").preview_scrolling_down,
						["K"] = require("telescope.actions").preview_scrolling_up,
						["H"] = require("telescope.actions").preview_scrolling_left,
						["L"] = require("telescope.actions").preview_scrolling_right,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					file_ignore_patterns = { "%.git/", "^node_modules/", "^.venv/" },
          theme = "ivy",
				},
				live_grep = {
					additional_args = function()
						return { "--hidden" }
					end,
				},
        buffers = {
          theme = "ivy",
          sort_mru = true,
          sort_last = true,
          initial_mode = "normal",
        }
			},
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        yanky_history = {},
      }


		},
		keys = {
			{ "<space>gf", function() require("custom.telescope.multigrep")() end, desc = "Grep string with file" },
			{ "<space>gs", "<cmd>Telescope grep_string<CR>", desc = "Grep string" },
			{ "<space>p", "<cmd>Telescope find_files<CR>", desc = "Find files" },
			{ "<space>b", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
			{ "<space>k", "<cmd>Telescope keymaps<CR>", desc = "Telescope Keymaps" },
			{ "gd", "<cmd>Telescope lsp_definitions<CR>", desc = "LSP Definitions" },
			{ "gr", "<cmd>Telescope lsp_references<CR>", desc = "LSP References" },
		},
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)

      telescope.load_extension("fzf")
      telescope.load_extension("undo")
      telescope.load_extension("yanky_history")
		end,
	},
}

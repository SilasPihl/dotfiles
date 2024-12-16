return {
  "ray-x/go.nvim",
  dependencies = {                     -- optional packages
    "ray-x/guihua.lua",                -- UI components for Go.nvim
    "neovim/nvim-lspconfig",           -- LSP support
    "nvim-treesitter/nvim-treesitter", -- Syntax highlighting and parsing
  },
  config = function()
    -- Setup Go.nvim
    require("go").setup()

    -- Create an autocmd for running Go tests on save for *_test.go files
    vim.api.nvim_create_autocmd('BufWritePost', {
      desc = 'Run Go tests on save for *_test.go files',
      group = vim.api.nvim_create_augroup('run-go-tests-on-save', { clear = true }),
      pattern = '*_test.go',
      callback = function()
        require('neotest').run.run(vim.fn.expand('%'))
      end,
    })
  end,
  event = { "CmdlineEnter" },
  ft = { "go", "gomod" },
  build = ':lua require("go.install").update_all_sync()',
}

return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "nixfmt" },
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)
  end,
}

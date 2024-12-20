return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      auto_install = true,
      highlight = {
        enable = true,
      },
      ensure_installed = {
        "bash",
        "json",
        "lua",
        "make",
        "go",
        "markdown",
        "nix",
        "regex",
        "rego",
        "toml",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}

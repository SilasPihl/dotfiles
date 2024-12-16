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
        "go",
        "gomod",
        "gosum",
        "gowork",
        "json",
        "lua",
        "make",
        "markdown",
        "nix",
        "regex",
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

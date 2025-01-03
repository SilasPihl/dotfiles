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
        "diff",
        "lua",
        "go",
        "gowork",
        "gomod",
        "gosum",
        "sql",
        "gotmpl",
        "json",
        "comment",
        "make",
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

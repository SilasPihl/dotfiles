return {
  {
    "tadaa/vimade",
    opts = {
      recipe = { "minimalist", { animate = false } }, -- Minimalist recipe with animations
      ncmode = "windows", -- Fade inactive windows
      fadelevel = 0.5, -- Set fade level to 50%
      tint = {
        bg = { rgb = { 10, 10, 10 }, intensity = 0.2 }, -- Add slight dark tint to inactive windows
      },
      enablefocusfading = true, -- Smooth transitions when switching focus
      checkinterval = 500, -- Faster window checks for real-time updates
    },
    config = function(_, opts)
      require("vimade").setup(opts)
      vim.cmd([[
        highlight DimBackground guibg=#1c1c1c guifg=NONE
      ]])
    end,
  },
}

return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    routes = {
      {
        filter = {
          event = 'msg_show',
          find = '%+10',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          find = '%-10',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'cmdline',
          find = '%+10',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'cmdline',
          find = '%-10',
        },
        opts = { skip = true },
      },
      -- Suppress the output for Neotree reveal command
      {
        filter = {
          event = 'cmdline',
          find = 'Neotree reveal',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          find = 'Neotree reveal',
        },
        opts = { skip = true },
      },
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
}

return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    -- add any options here
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
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
}

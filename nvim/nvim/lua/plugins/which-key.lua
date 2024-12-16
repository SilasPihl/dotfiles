return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  config = function()
    require('which-key').setup({
      delay = 200,
      expand = 1,
      notify = false,
      preset = false,
      replace = {
        desc = {
          { "<space>", "SPACE" },
          { "<leader>", "SPACE" },
          { "<[cC][rR]>", "RETURN" },
          { "<[tT][aA][bB]>", "TAB" },
          { "<[bB][sS]>", "BACKSPACE" },
        },
      },
      win = { border = "single" },
    })

    -- Key mappings configuration
    local wk = require('which-key')
    wk.register({
      ["<leader>b"] = { name = "󰓩 Buffer" },
      ["<leader>w"] = { name = "Windows", proxy = "<C-w>" },
      ["<C-g>"] = { name = "Gp Commands" },
      ["<C-g>t"] = { "<cmd>CopilotChatToggle<CR>", "Copilot Chat Toggle" },
      ["<C-g>f"] = { "<cmd>CopilotChatFix<CR>", "Copilot Chat Fix", mode = "v" },
      ["<leader>dt"] = { ":dapuitoggle<cr>", "dap ui toggle" },
      ["<leader>db"] = { ":daptogglebreakpoint<cr>", "dap toggle breakpoint" },
      ["<leader>dc"] = { ":dapcontinue<cr>", "dap continue" },
      ["<leader>dr"] = { ":lua require('dapui').open({reset=true})<cr>", "dap restart" },
    })
  end,
}

vim.keymap.set("t", "<esc>", "<c-\\><c-n>")

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf
  if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    focusable = true,
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local function stop_terminal_job()
  if vim.api.nvim_buf_is_valid(state.floating.buf) then
    local job_id = vim.b[state.floating.buf].terminal_job_id
    if job_id and job_id > 0 then
      vim.fn.jobstop(job_id)
    end
    vim.api.nvim_buf_delete(state.floating.buf, { force = true }) -- Delete the buffer
  end
end

local function toggle_terminal()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    -- Create the floating window and terminal buffer
    state.floating = create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd("terminal zsh")
      vim.api.nvim_feedkeys("i", "n", false)
    end

    vim.api.nvim_create_autocmd("BufWipeout", {
      buffer = state.floating.buf,
      callback = function()
        state.floating = { buf = -1, win = -1 }
      end,
    })
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    stop_terminal_job()
  end,
})

vim.keymap.set({ "n", "t" }, "<C-t>", toggle_terminal)
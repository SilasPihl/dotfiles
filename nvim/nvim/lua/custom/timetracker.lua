local TimeTracker = {}

local function start_dim()
  require("vimade").setup({
    ncmode = "windows",
    fadelevel = 0.2,
    tint = {
      bg = { rgb = { 0, 0, 0 }, intensity = 0.2 },
    },
  })
  vim.cmd("VimadeEnable")
end

local function stop_dim()
  vim.cmd("VimadeDisable")
end

function TimeTracker:new(options)
  options = options or {}
  self.__index = self
  return setmetatable(options, self)
end

function TimeTracker:report(day, hours)
  if not hours or tonumber(hours) == nil or tonumber(hours) <= 0 then
    self:notify("Invalid input. Please provide a valid number of hours.")
    return
  end

  local total_minutes = math.floor(tonumber(hours) * 60)
  local current_time = os.time({
    year = tonumber(os.date("%Y")),
    month = tonumber(os.date("%m")),
    day = tonumber(os.date("%d")),
    hour = 9,
    min = 0,
  })

  local end_time = os.date("%H:%M", current_time + total_minutes * 60)
  local command = "timew track 09:00 - " .. end_time .. " :adjust"
  vim.fn.system(command)
  self:notify("Reported " .. tostring(hours) .. " hours from 09:00 to " .. end_time .. " for " .. (day or "today"))
end

function TimeTracker:get_summary(range)
  range = range or ":month"
  local command = "timew month " .. range
  local result = vim.fn.system(command)

  if result == "" then
    return { "No entries found." }
  end
  return vim.split(result, "\n")
end

function TimeTracker:delete_entry(id)
  if not id or id == "" then
    self:notify("Invalid entry ID. Please provide a valid ID to delete.")
    return
  end

  local command = "timew delete " .. id
  local result = vim.fn.system(command)
  if result == "" then
    self:notify("Successfully deleted entry with ID: " .. id)
  else
    self:notify("Failed to delete entry. Error: " .. result)
  end
end

function TimeTracker:notify(msg)
  vim.notify(msg, vim.log.levels.INFO, { title = "TimeTracker" })
end

function TimeTracker:report_today()
  vim.ui.input({ prompt = "Enter hours for today:" }, function(hours)
    if hours then
      self:report("today", hours)
    else
      self:notify("No input provided.")
    end
  end)
end

function TimeTracker:report_specific_date()
  vim.ui.input({ prompt = "Enter the date (YYYY-MM-DD):" }, function(date)
    if date then
      vim.ui.input({ prompt = "Enter hours for " .. date .. ":" }, function(hours)
        if hours then
          self:report(date, hours)
        else
          self:notify("No input provided.")
        end
      end)
    else
      self:notify("No input provided.")
    end
  end)
end

function TimeTracker:show_overview()
  vim.ui.input({ prompt = "Enter year and month (YYYY-MM) or leave blank for this month:" }, function(input)
    local range = ":month"
    if input and input ~= "" then
      range = input
    end

    local summary = self:get_summary(range)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "swapfile", false)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, summary)

    start_dim()

    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = math.floor(vim.o.columns * 0.6),
      height = math.floor(vim.o.lines * 0.4),
      row = math.floor(vim.o.lines * 0.3),
      col = math.floor(vim.o.columns * 0.2),
      style = "minimal",
      border = "rounded",
    })

    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })

    vim.api.nvim_create_autocmd("BufWinLeave", {
      buffer = buf,
      callback = function()
        stop_dim()
      end,
    })
  end)
end

vim.api.nvim_create_user_command("TimeTrackerReportToday", function()
  local tracker = TimeTracker:new()
  tracker:report_today()
end, {})

vim.api.nvim_create_user_command("TimeTrackerReportDate", function()
  local tracker = TimeTracker:new()
  tracker:report_specific_date()
end, {})

vim.api.nvim_create_user_command("TimeTrackerOverview", function()
  local tracker = TimeTracker:new()
  tracker:show_overview()
end, {})

vim.api.nvim_create_user_command("TimeTrackerDeleteEntry", function()
  local tracker = TimeTracker:new()
  vim.ui.input({ prompt = "Enter the ID of the entry to delete:" }, function(id)
    if id and id ~= "" then
      tracker:delete_entry(id)
    else
      tracker:notify("No ID provided.")
    end
  end)
end, {})

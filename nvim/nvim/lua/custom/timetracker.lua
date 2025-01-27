local TimeTracker = {}

local Popup = require("nui.popup")
local NuiText = require("nui.text")
local event = require("nui.utils.autocmd").event

-- Utility: Start dimming
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

-- Utility: Stop dimming
local function stop_dim()
  vim.cmd("VimadeDisable")
end

-- Constructor
function TimeTracker:new(options)
  options = options or {}
  self.__index = self
  return setmetatable(options, self)
end

-- Report time with validation and notify
function TimeTracker:report(day, hours, tags)
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
  local tag_command = tags and (#tags > 0 and " " .. table.concat(tags, " ") or "") or ""
  local command = "timew track 09:00 - " .. end_time .. " :adjust" .. tag_command

  vim.fn.system(command)
  self:notify(
    "Reported "
      .. tostring(hours)
      .. " hours from 09:00 to "
      .. end_time
      .. " for "
      .. (day or "today")
      .. (tags and " with tags: " .. table.concat(tags, ", ") or "")
  )
end

-- Get and display a summary report in a popup
function TimeTracker:get_summary(range)
  -- Use the "timew summary :month :ids" command
  local command = { "timew", "summary", ":month", ":ids" }

  -- Start dimming the background
  if start_dim then
    start_dim()
  else
    vim.notify("Dimming function not found", vim.log.levels.WARN, { title = "TimeTracker" })
  end

  local popup = Popup({
    position = "50%",
    size = {
      width = math.floor(vim.o.columns * 0.6), -- Adjusted width for narrower content
      height = math.floor(vim.o.lines * 0.4), -- Adjusted height for compact content
    },
    border = {
      style = "rounded",
      text = {
        top = " Time Report (Month) ",
        top_align = "center",
        bottom = NuiText("Press 'q' to close", "Comment"),
        bottom_align = "center",
      },
    },
    win_options = {
      winblend = 0, -- Remove transparency
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  })

  popup:mount()

  -- Close the popup and stop dimming with 'q'
  popup:map("n", "q", function()
    if stop_dim then
      stop_dim()
    else
      vim.notify("Dimming stop function not found", vim.log.levels.WARN, { title = "TimeTracker" })
    end
    popup:unmount()
  end, { noremap = true })

  -- Auto-unmount and stop dimming when the buffer is left
  popup:on(event.BufLeave, function()
    if stop_dim then
      stop_dim()
    else
      vim.notify("Dimming stop function not found", vim.log.levels.WARN, { title = "TimeTracker" })
    end
    popup:unmount()
  end)

  -- Run the "timew summary :month :ids" command and populate the popup
  vim.fn.jobstart(command, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 0 then
        vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, data)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, { "Error fetching data:", unpack(data) })
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.api.nvim_buf_set_lines(
          popup.bufnr,
          0,
          -1,
          false,
          { "Error fetching data. Command exited with code:", tostring(exit_code) }
        )
      elseif vim.api.nvim_buf_line_count(popup.bufnr) == 0 then
        vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, { "No time tracking data found for this month." })
      end
    end,
  })
end

-- Notify messages
function TimeTracker:notify(msg)
  vim.notify(msg, vim.log.levels.INFO, { title = "TimeTracker" })
end

-- Input UI for reporting time today
function TimeTracker:report_today()
  vim.ui.input({ prompt = "Enter hours for today:" }, function(hours)
    if hours then
      vim.ui.input({ prompt = "Enter tags (comma-separated, optional):" }, function(tags_input)
        local tags = tags_input and vim.split(tags_input, ",%s*") or {}
        self:report("today", hours, tags)
      end)
    else
      self:notify("No input provided.")
    end
  end)
end

-- Input UI for reporting time on a specific date
function TimeTracker:report_specific_date()
  vim.ui.input({ prompt = "Enter the date (YYYY-MM-DD):" }, function(date)
    if date then
      vim.ui.input({ prompt = "Enter hours for " .. date .. ":" }, function(hours)
        if hours then
          vim.ui.input({ prompt = "Enter tags (comma-separated, optional):" }, function(tags_input)
            local tags = tags_input and vim.split(tags_input, ",%s*") or {}
            self:report(date, hours, tags)
          end)
        else
          self:notify("No input provided.")
        end
      end)
    else
      self:notify("No input provided.")
    end
  end)
end

-- Overview Popup for a selected range
function TimeTracker:show_overview()
  vim.ui.input({ prompt = "Enter year and month (YYYY-MM) or leave blank for this month:" }, function(input)
    local range = input and input ~= "" and input or ":month"
    self:get_summary(range)
  end)
end

-- User Commands
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

return TimeTracker
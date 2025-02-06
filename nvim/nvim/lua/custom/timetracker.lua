local TimeTracker = {}

local Popup = require("nui.popup")
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
function TimeTracker:report(day, hours)
  if not hours or tonumber(hours) == nil or tonumber(hours) <= 0 then
    self:notify("Invalid input. Please provide a valid number of hours.")
    return
  end

  local date_str
  if day == "today" then
    date_str = os.date("%Y-%m-%d")
  elseif day == "yesterday" then
    date_str = os.date("%Y-%m-%d", os.time() - 86400)
  else
    date_str = day
  end

  -- I don't care about times of the day as I report in full days
  local start_time = date_str .. " 09:00"

  local start_epoch = os.time({
    year = tonumber(date_str:sub(1, 4)),
    month = tonumber(date_str:sub(6, 7)),
    day = tonumber(date_str:sub(9, 10)),
    hour = 9,
    min = 0,
  })
  local end_epoch = start_epoch + (tonumber(hours) * 3600)
  local end_time = os.date("%Y-%m-%d %H:%M", end_epoch)

  self:exec("in", { "-a", start_time })
  self:exec("edit", { "--end", end_time })
  self:notify("Reported " .. tostring(hours) .. " hours from 09:00 to " .. end_time:sub(12, 16) .. " on " .. date_str)
end

function TimeTracker:__build_command(cmd, args)
  if not cmd or cmd == "" then
    error("Command cannot be empty")
  end

  -- Helper function to quote an argument if it contains whitespace.
  local function quoteArg(arg)
    if string.find(arg, "%s") then
      return '"' .. arg .. '"'
    else
      return arg
    end
  end

  local command = "timetrap " .. cmd
  if args and #args > 0 then
    local quotedArgs = {}
    for _, a in ipairs(args) do
      table.insert(quotedArgs, quoteArg(a))
    end
    command = command .. " " .. table.concat(quotedArgs, " ")
  end

  return command
end

function TimeTracker:exec(cmd, args)
  local command = self:__build_command(cmd, args)
  local result = table.concat(vim.fn.systemlist(command), "\n")
  return result
end

function TimeTracker:get_summary()
  -- Automatically use the current month.
  local month_param = os.date("%Y-%m")
  local cmd = "month --ids --round --start "
    .. month_param
    .. " 2>/dev/null | rg -v '^\\s*\\d{1,2}:\\d{2}:\\d{2}\\s*$' | rg -v 'Notes'"
  local result = self:exec(cmd)

  if start_dim then
    start_dim()
  else
    vim.notify("Dimming function not found", vim.log.levels.WARN, { title = "TimeTracker" })
  end

  local main_width = math.floor(vim.o.columns * 0.4)
  local main_height = math.floor(vim.o.lines * 0.6)
  local doc_height = 7
  local total_height = main_height + doc_height

  local top = math.floor((vim.o.lines - total_height) / 2)
  local left = math.floor((vim.o.columns - main_width) / 2)

  local popup = Popup({
    position = { row = top, col = left },
    size = {
      width = main_width,
      height = main_height,
    },
    border = {
      style = "rounded",
      text = {
        top = " Overview ",
        top_align = "center",
      },
    },
    win_options = {
      winblend = 0,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  })

  local doc_popup = Popup({
    position = { row = top + main_height + 2, col = left },
    size = {
      width = main_width,
      height = doc_height,
    },
    border = {
      style = "rounded",
      text = {
        top = " Keys ",
        top_align = "center",
      },
    },
    win_options = {
      winblend = 0,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  })

  popup:mount()
  doc_popup:mount()
  vim.api.nvim_set_current_win(popup.winid)

  -- Helper function to refresh the main popup content.
  local function refresh_popup()
    local new_result = self:exec(cmd)
    local new_lines = vim.split(new_result, "\n", { plain = true })
    if #new_lines == 0 then
      new_lines = { "No time tracking data found." }
    end
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, new_lines)
  end

  local lines = vim.split(result, "\n", { plain = true })
  if #lines == 0 then
    lines = { "No time tracking data found." }
  end
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)

  -- Documentation lines.
  local doc_lines = {
    "'a': Add entry today",
    "'d': Add entry on specific date",
    "'e': Edit entry",
    "'s': Select new monthly report",
    "'x': Delete entry",
    "'y': Add entry yesterday",
    "'q': Quit",
  }
  vim.api.nvim_buf_set_lines(doc_popup.bufnr, 0, -1, false, doc_lines)

  -- Key mapping: close both popups with 'q'.
  vim.api.nvim_buf_set_keymap(popup.bufnr, "n", "q", "", {
    noremap = true,
    nowait = true,
    silent = true,
    callback = function()
      if stop_dim then
        stop_dim()
      end
      popup:unmount()
      doc_popup:unmount()
    end,
  })

  -- Key mapping: edit an entry.
  vim.api.nvim_buf_set_keymap(popup.bufnr, "n", "e", "", {
    noremap = true,
    nowait = true,
    silent = true,
    callback = function()
      vim.ui.input({ prompt = "Enter entry id to edit:" }, function(id)
        if id and id ~= "" then
          vim.ui.input({ prompt = "Enter new hours:" }, function(hours)
            if hours and tonumber(hours) then
              local date_str = os.date("%Y-%m-%d")
              local new_end_time = os.date("%Y-%m-%d %H:%M", os.time({
                year = tonumber(date_str:sub(1, 4)),
                month = tonumber(date_str:sub(6, 7)),
                day = tonumber(date_str:sub(9, 10)),
                hour = 9,
                min = 0,
              }) + (tonumber(hours) * 3600))
              self:exec("edit", { "--id", id, "--end", new_end_time })
              self:notify("Updated entry " .. id .. " with " .. hours .. " hours worked.")
              refresh_popup()
            else
              self:notify("Invalid hours provided.")
            end
          end)
        else
          self:notify("No id provided.")
        end
      end)
    end,
  })

  -- Key mapping: delete an entry.
  vim.api.nvim_buf_set_keymap(popup.bufnr, "n", "x", "", {
    noremap = true,
    nowait = true,
    silent = true,
    callback = function()
      vim.ui.input({ prompt = "Enter entry id to delete:" }, function(id)
        if id and id ~= "" then
          self:exec("kill", { "--id", id, "--yes" })
          self:notify("Deleted entry " .. id .. ".")
          refresh_popup()
        else
          self:notify("No id provided.")
        end
      end)
    end,
  })

  -- Key mapping: add a new time entry for today.
  vim.api.nvim_buf_set_keymap(popup.bufnr, "n", "a", "", {
    noremap = true,
    nowait = true,
    silent = true,
    callback = function()
      vim.ui.input({ prompt = "Enter hours for today:" }, function(hours)
        if hours and tonumber(hours) then
          self:report("today", hours)
          self:notify("Reported " .. hours .. " hours for today.")
          refresh_popup()
        else
          self:notify("Invalid hours provided.")
        end
      end)
    end,
  })

  -- Key mapping: add a new time entry for yesterday.
  vim.api.nvim_buf_set_keymap(popup.bufnr, "n", "y", "", {
    noremap = true,
    nowait = true,
    silent = true,
    callback = function()
      vim.ui.input({ prompt = "Enter hours for yesterday:" }, function(hours)
        if hours and tonumber(hours) then
          self:report("yesterday", hours)
          self:notify("Reported " .. hours .. " hours for yesterday.")
          refresh_popup()
        else
          self:notify("Invalid hours provided.")
        end
      end)
    end,
  })

  -- Key mapping: add a new time entry for a specific date.
  vim.api.nvim_buf_set_keymap(popup.bufnr, "n", "d", "", {
    noremap = true,
    nowait = true,
    silent = true,
    callback = function()
      vim.ui.input({ prompt = "Enter date (YYYY-MM-DD):" }, function(date)
        if date and date ~= "" then
          vim.ui.input({ prompt = "Enter hours for " .. date .. ":" }, function(hours)
            if hours and tonumber(hours) then
              self:report(date, hours)
              self:notify("Reported " .. hours .. " hours for " .. date .. ".")
              refresh_popup()
            else
              self:notify("Invalid hours provided.")
            end
          end)
        else
          self:notify("No date provided.")
        end
      end)
    end,
  })

  -- Key mapping: press 's' to select a new monthly report.
  vim.api.nvim_buf_set_keymap(popup.bufnr, "n", "s", "", {
    noremap = true,
    nowait = true,
    silent = true,
    callback = function()
      vim.ui.input({ prompt = "Enter month (YYYY-MM):" }, function(input)
        if input and input ~= "" then
          month_param = input
          cmd = "month --ids --round --start " .. month_param .. " 2>/dev/null"
          refresh_popup()
        else
          self:notify("Invalid month provided.")
        end
      end)
    end,
  })

  popup:on(event.BufLeave, function()
    if stop_dim then
      stop_dim()
    end
    popup:unmount()
    doc_popup:unmount()
  end)
end

function TimeTracker:notify(msg)
  Snacks.notify.info(msg, { title = "TimeTracker" })
end

function TimeTracker:show_overview()
  self:get_summary()
end

vim.api.nvim_create_user_command("TimeTrackerOverview", function()
  local tracker = TimeTracker:new()
  tracker:show_overview()
end, {})

-- Key mapping for the overview popup
vim.keymap.set("n", "<leader>t", function()
  vim.cmd("silent! TimeTrackerOverview")
end, { silent = true, desc = "TimeTracker" })

return TimeTracker
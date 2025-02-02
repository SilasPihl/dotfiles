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
function TimeTracker:report(day, hours)
  if not hours or tonumber(hours) == nil or tonumber(hours) <= 0 then
    self:notify("Invalid input. Please provide a valid number of hours.")
    return
  end

  -- Determine the correct date format
  local date_str = (day == "today") and os.date("%Y-%m-%d") or day

  -- Start time is fixed at 09:00
  local start_time = date_str .. " 09:00"
  local end_time = os.date("%Y-%m-%d %H:%M", os.time({
    year = tonumber(date_str:sub(1, 4)),
    month = tonumber(date_str:sub(6, 7)),
    day = tonumber(date_str:sub(9, 10)),
    hour = 9,
    min = 0,
  }) + (tonumber(hours) * 3600))

  -- Start tracking time
  self:exec("in", { "-a", start_time })

  -- Stop tracking time
  self:exec("edit", { "--end", end_time })

  -- Notify success
  self:notify("Reported " .. tostring(hours) .. " hours from 09:00 to " .. end_time:sub(12, 16) .. " on " .. date_str)
end

-- Build shell command from command and arguments
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

-- Execute a shell command and return the result
function TimeTracker:exec(cmd, args)
  local command = self:__build_command(cmd, args)
  local result = table.concat(vim.fn.systemlist(command), "\n")
  return result
end

-- Get and display a summary report in a popup
function TimeTracker:get_summary()
  -- Prompt for the month (YYYY-MM); if nothing is entered, default to the current month.
  vim.ui.input({ prompt = "Enter month (YYYY-MM) [default: current month]:" }, function(input)
    local month_param = (input and input ~= "") and input or os.date("%Y-%m")
    -- Build the timetrap month command using --start with the specified month.
    local cmd = "month --ids --round --start " .. month_param .. " 2>/dev/null"
    local result = self:exec(cmd)

    -- Start dimming if available.
    if start_dim then
      start_dim()
    else
      vim.notify("Dimming function not found", vim.log.levels.WARN, { title = "TimeTracker" })
    end

    -- Create the popup.
    local popup = Popup({
      position = "50%",
      size = {
        width = math.floor(vim.o.columns * 0.6),
        height = math.floor(vim.o.lines * 0.6),
      },
      border = {
        style = "rounded",
        text = {
          top = " Time Report (Month) ",
          top_align = "center",
          bottom = NuiText(
            "Press 'q' to close, 'e' to edit, 'x' to delete, 'a' to add today, 'd' to add date",
            "Comment"
          ),
          bottom_align = "center",
        },
      },
      win_options = {
        winblend = 0,
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
    })

    popup:mount()
    vim.api.nvim_set_current_win(popup.winid)

    -- Helper function to refresh the popup content using the same command.
    local function refresh_popup()
      local new_result = self:exec(cmd)
      local new_lines = vim.split(new_result, "\n", { plain = true })
      if #new_lines == 0 then
        new_lines = { "No time tracking data found." }
      end
      vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, new_lines)
    end

    -- Set the initial popup content.
    local lines = vim.split(result, "\n", { plain = true })
    if #lines == 0 then
      lines = { "No time tracking data found." }
    end
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)

    -- Key mapping: close the popup with 'q'.
    vim.api.nvim_buf_set_keymap(popup.bufnr, "n", "q", "", {
      noremap = true,
      nowait = true,
      silent = true,
      callback = function()
        if stop_dim then
          stop_dim()
        end
        popup:unmount()
      end,
    })

    -- Key mapping: edit an entry when 'e' is pressed.
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

    -- Key mapping: delete an entry when 'x' is pressed.
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

    -- Key mapping: add a new time entry for today when 'a' is pressed.
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

    -- Key mapping: add a new time entry for a specific date when 'd' is pressed.
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

    -- When the popup buffer is left, disable dimming and unmount the popup.
    popup:on(event.BufLeave, function()
      if stop_dim then
        stop_dim()
      end
      popup:unmount()
    end)
  end)
end

-- Notify messages
function TimeTracker:notify(msg)
  vim.notify(msg, vim.log.levels.INFO, { title = "TimeTracker" })
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
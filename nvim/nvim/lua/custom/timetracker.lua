local fn = {}

function fn.trim(str)
  return (str:gsub("^%s*(.-)%s*$", "%1"))
end

local TimeTracker = {}
local ui_open = false -- Track UI state
local help_visible = false -- Track Help Box state

function TimeTracker:new(options)
  options = options or {}
  self.__index = self
  return setmetatable(options, self)
end

function TimeTracker:report(day, hours)
  -- Ensure input hours is valid
  if not hours or tonumber(hours) == nil or tonumber(hours) <= 0 then
    self:notify("Invalid input. Please provide a valid number of hours.")
    return
  end

  -- Validate and convert hours input to a number
  local total_minutes = math.floor(tonumber(hours) * 60) -- Convert hours to minutes

  -- Calculate the end time based on the start time (09:00) and input hours
  local current_time = os.time({
    year = tonumber(os.date("%Y")),
    month = tonumber(os.date("%m")),
    day = tonumber(os.date("%d")),
    hour = 9, -- Starting hour: 09:00
    min = 0,
  })

  local end_time = os.date("%H:%M", current_time + total_minutes * 60) -- Add minutes in seconds

  local command = "timew track 09:00 - " .. end_time .. " :adjust"
  vim.fn.system(command)
  self:notify("Reported " .. tostring(hours) .. " hours from 09:00 to " .. end_time .. " for " .. (day or "today"))
  self:refresh_summary()
end

function TimeTracker:get_month_summary()
  local command = "timew summary :month"
  local result = vim.fn.systemlist(command)
  if #result == 0 then
    result = { "No entries found for this month." }
  end
  return result
end

function TimeTracker:notify(msg)
  require("snacks").notifier.notify(msg, "info", { title = "TimeTracker" })
end

function TimeTracker:refresh_summary()
  if self.top_popup and vim.api.nvim_buf_is_valid(self.top_popup.bufnr) then
    local latest_entries = self:get_month_summary()
    vim.api.nvim_buf_set_option(self.top_popup.bufnr, "modifiable", true) -- Ensure the buffer is modifiable
    vim.api.nvim_buf_set_lines(self.top_popup.bufnr, 0, -1, false, latest_entries) -- Update the buffer with new lines
    vim.api.nvim_buf_set_option(self.top_popup.bufnr, "modifiable", false) -- Lock the buffer again
  end
end

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

function TimeTracker:toggle_help_box()
  if help_visible then
    if self.help_popup and vim.api.nvim_buf_is_valid(self.help_popup.bufnr) then
      self.help_popup:unmount()
    end
    help_visible = false
  else
    local Popup = require("nui.popup")

    local screen_width = vim.o.columns
    local screen_height = vim.o.lines

    self.help_popup = Popup({
      enter = false,
      focusable = false,
      border = "rounded",
      size = {
        width = math.floor(screen_width * 0.2),
        height = math.floor(screen_height * 0.25),
      },
      position = {
        row = math.floor(screen_height * -0.15),
        col = math.floor(screen_width * 0.3),
      },
    })

    vim.api.nvim_buf_set_lines(self.help_popup.bufnr, 0, -1, false, {
      "Help Tips:",
      "- Press '1' to report hours for today.",
      "- Press '2' to report hours for a specific date.",
      "- Press 'q' to close the UI.",
      "- Press 'h' to toggle this help box.",
      "- Press Backspace to go back.",
    })

    self.help_popup:mount()
    help_visible = true
  end
end

function TimeTracker:show_main_ui()
  if ui_open then
    self:close_ui()
    return
  end

  ui_open = true
  start_dim()

  local Popup = require("nui.popup")
  local Layout = require("nui.layout")

  -- Screen dimensions
  local screen_width = vim.o.columns
  local screen_height = vim.o.lines

  -- Adjustable box dimensions and positions
  local box_width = math.floor(screen_width * 0.275) -- Significantly wider boxes
  local top_box_height = math.floor(screen_height * 0.4) -- Larger top box height
  local bottom_box_height = math.floor(screen_height * 0.3) -- Larger bottom box height
  local box_position_x = math.floor((screen_width - box_width) / 2) -- Center horizontally
  local top_box_position_y = math.floor(screen_height * 0.1) -- Adjusted vertical position for the top box
  local bottom_box_position_y = top_box_position_y + top_box_height + 1 -- Below the top box

  -- Top popup
  self.top_popup = Popup({
    enter = false,
    focusable = false,
    border = "rounded",
    size = {
      width = box_width,
      height = top_box_height,
    },
    position = {
      row = top_box_position_y,
      col = box_position_x,
    },
  })

  vim.api.nvim_buf_set_lines(self.top_popup.bufnr, 0, -1, false, self:get_month_summary())

  -- Bottom popup
  self.bottom_popup = Popup({
    enter = true,
    focusable = true,
    border = "rounded",
    size = {
      width = box_width,
      height = bottom_box_height,
    },
    position = {
      row = bottom_box_position_y,
      col = box_position_x,
    },
  })

  local function update_bottom_popup(lines)
    vim.api.nvim_buf_set_lines(self.bottom_popup.bufnr, 0, -1, false, lines)
  end

  local function show_initial_menu()
    update_bottom_popup({
      "Options:",
      "1. Report time",
      "2. Get report",
    })
  end

  local function show_report_time_menu(tracker)
    local function prompt_for_input(prompt_text, callback)
      -- Use Dressing.nvim's vim.ui.input implementation
      vim.ui.input({ prompt = prompt_text, default = "" }, function(input)
        if input and input ~= "" then
          callback(input) -- Pass the input to the callback
        else
          tracker:notify("No input provided")
        end
      end)
    end

    -- Show the report time menu
    vim.api.nvim_buf_set_lines(tracker.bottom_popup.bufnr, 0, -1, false, {
      "Report Time:",
      "1. Today",
      "2. Specific date",
    })

    vim.keymap.set("n", "1", function()
      prompt_for_input("Enter the amount of hours for today:", function(hours)
        tracker:report("today", hours) -- Report hours for today
      end)
    end, { buffer = tracker.bottom_popup.bufnr, noremap = true, silent = true })

    vim.keymap.set("n", "2", function()
      prompt_for_input("Enter the date (YYYY-MM-DD):", function(date)
        prompt_for_input("Enter the amount of hours:", function(hours)
          tracker:report(date, hours) -- Report hours for the specific date
        end)
      end)
    end, { buffer = tracker.bottom_popup.bufnr, noremap = true, silent = true })
  end

  show_initial_menu()

  vim.keymap.set("n", "1", function()
    show_report_time_menu(self)
  end, { buffer = self.bottom_popup.bufnr, noremap = true, silent = true })

  vim.keymap.set("n", "q", function()
    self:close_ui()
  end, { buffer = self.bottom_popup.bufnr, noremap = true, silent = true })

  vim.keymap.set("n", "h", function()
    self:toggle_help_box()
  end, { buffer = self.bottom_popup.bufnr, noremap = true, silent = true })

  vim.keymap.set("n", "<BS>", function()
    show_initial_menu()
  end, { buffer = self.bottom_popup.bufnr, noremap = true, silent = true })

  self.layout = Layout(
    {
      position = "50%",
      size = {
        width = box_width, -- Use calculated width
        height = top_box_height + bottom_box_height + 1, -- Combined height of both boxes
      },
    },
    Layout.Box({
      Layout.Box(self.top_popup, { size = top_box_height / (top_box_height + bottom_box_height) }),
      Layout.Box(self.bottom_popup, { size = bottom_box_height / (top_box_height + bottom_box_height) }),
    }, { dir = "col" })
  )

  self.layout:mount()
end

function TimeTracker:close_ui()
  if ui_open then
    ui_open = false
    if self.layout then
      self.layout:unmount()
    end
    if help_visible and self.help_popup then
      self.help_popup:unmount()
    end
    stop_dim()
    help_visible = false
  end
end

local timetracker = TimeTracker:new()

vim.api.nvim_create_user_command("TimeTracker", function()
  timetracker:show_main_ui()
end, {})

vim.keymap.set("n", "<leader>t", function()
  timetracker:show_main_ui()
end, { noremap = true, silent = true, desc = "Time tracker" })

return timetracker
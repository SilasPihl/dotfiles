{ pkgs, user, ... }:
{
  home.file.".hammerspoon/init.lua".text = ''
    -- ---------- Named Screen Helpers ----------
    local function allScreenNames()
        local names = {}
        for _, s in ipairs(hs.screen.allScreens()) do table.insert(names, s:name()) end
        return table.concat(names, ", ")
    end

    -- Find a screen by:
    -- - special tokens: :primary, :current, :ipad, :builtin
    -- - exact name match
    -- - partial (case-insensitive) name match
    local function findScreenByKey(key)
        if key == ":primary" then return hs.screen.primaryScreen() end
        if key == ":current" then return hs.mouse.getCurrentScreen() end

        if key == ":ipad" then
            for _, s in ipairs(hs.screen.allScreens()) do
                local n = s:name():lower()
                if n:find("ipad", 1, true) or n:find("sidecar", 1, true) then
                    return s
                end
            end
            return nil
        end

        if key == ":builtin" then
            local needles = { "built", "color lcd", "retina", "macbook", "internal" }
            for _, s in ipairs(hs.screen.allScreens()) do
                local n = s:name():lower()
                for _, needle in ipairs(needles) do
                    if n:find(needle, 1, true) then return s end
                end
            end
            -- Fallback: primary screen if we didn't find a typical built-in name
            return hs.screen.primaryScreen()
        end

        -- Exact name
        for _, s in ipairs(hs.screen.allScreens()) do
            if s:name() == key then return s end
        end

        -- Partial, case-insensitive
        local needle = key:lower()
        for _, s in ipairs(hs.screen.allScreens()) do
            if s:name():lower():find(needle, 1, true) then return s end
        end

        return nil
    end

    local function moveMouseToScreen(scr)
        local f = scr:fullFrame()
        hs.mouse.setAbsolutePosition({ x = f.x + f.w / 2, y = f.y + f.h / 2 })
        hs.alert.show("Mouse → " .. scr:name())
    end

    local function moveMouseToFocusedWindow()
        local win = hs.window.focusedWindow()
        if not win then
            hs.alert.show("No focused window")
            return
        end
        local frame = win:frame()
        hs.mouse.setAbsolutePosition({
            x = frame.x + frame.w / 2,
            y = frame.y + frame.h / 2
        })
        hs.alert.show("Mouse → " .. win:title())
    end

    local function gotoScreen(key)
        local scr = findScreenByKey(key)
        if not scr then
            hs.alert.show("Screen not found: " .. key)
            print("Available screens: " .. allScreenNames())
            return
        end
        moveMouseToScreen(scr)
    end

    local function moveWindowToScreen(scr)
        local win = hs.window.focusedWindow()
        if not win then
            hs.alert.show("No focused window")
            return
        end

        local currentScreen = win:screen()
        local frame = win:frame()
        local screenFrame = scr:frame()

        -- Tolerance for comparing window positions (in pixels)
        local tolerance = 10

        local function isApprox(a, b)
            return math.abs(a - b) < tolerance
        end

        -- Check if window is already on target screen
        if currentScreen == scr then
            -- Cycle through: full → left half → right half → full
            local isFullWidth = isApprox(frame.x, screenFrame.x) and
                               isApprox(frame.w, screenFrame.w)
            local isLeftHalf = isApprox(frame.x, screenFrame.x) and
                              isApprox(frame.w, screenFrame.w / 2)
            local isRightHalf = isApprox(frame.x, screenFrame.x + screenFrame.w / 2) and
                               isApprox(frame.w, screenFrame.w / 2)

            if isFullWidth then
                -- Move to left half
                win:moveToUnit({x=0, y=0, w=0.5, h=1})
                hs.alert.show("← Left half")
            elseif isLeftHalf then
                -- Move to right half
                win:moveToUnit({x=0.5, y=0, w=0.5, h=1})
                hs.alert.show("Right half →")
            else
                -- Move to full (including from right half or any other position)
                win:moveToUnit({x=0, y=0, w=1, h=1})
                hs.alert.show("⬛ Maximized")
            end
        else
            -- Move to new screen and maximize
            win:moveToScreen(scr)
            win:moveToUnit({x=0, y=0, w=1, h=1})
            hs.alert.show("Window → " .. scr:name() .. " (maximized)")
        end
    end

    local function moveWindowTo(key)
        local scr = findScreenByKey(key)
        if not scr then
            hs.alert.show("Screen not found: " .. key)
            print("Available screens: " .. allScreenNames())
            return
        end
        moveWindowToScreen(scr)
    end

    -- ---------- Named Screen Mappings ----------
    -- Replace "ASUS", "DELL", "LG" with your actual screen names if needed.
    -- You can also leave them as partials (e.g., "Asus", "Dell", "LG").
    local targetByKey = {
        q = "ASUS",     -- Option+Q → your ASUS display
        w = "DELL",     -- Option+W → your DELL display
        e = "LG",       -- Option+E → your LG display
        s = ":ipad",    -- Option+S → your iPad (Sidecar) display
        d = ":builtin", -- Option+D → your built-in Mac display
    }

    -- ---------- Named Screen Hotkeys ----------
    -- Option + key = move mouse to screen
    for key, target in pairs(targetByKey) do
        hs.hotkey.bind({ "alt" }, key, function() gotoScreen(target) end)
    end

    -- Ctrl + Option + key = move current window to screen
    for key, target in pairs(targetByKey) do
        hs.hotkey.bind({ "ctrl", "alt" }, key, function() moveWindowTo(target) end)
    end

    -- Option + M = move mouse to focused window
    hs.hotkey.bind({ "alt" }, "m", function() moveMouseToFocusedWindow() end)

    -- (Optional) Show all detected screen names with Option+Shift+S
    hs.hotkey.bind({ "alt", "shift" }, "s", function()
        hs.alert.show("Screens: " .. allScreenNames())
        print("Screens: " .. allScreenNames())
    end)

    -- ---------- Window Cycling on Current Screen ----------
    -- Cycle through all windows on the screen where mouse is located
    local function cycleWindowsOnCurrentScreen()
        local currentScreen = hs.mouse.getCurrentScreen()
        local currentWin = hs.window.focusedWindow()

        -- Get all visible windows on the current screen
        local windowsOnScreen = hs.fnutils.filter(
            hs.window.orderedWindows(),
            function(win)
                return win:screen() == currentScreen and
                       win:isStandard() and
                       win:isVisible()
            end
        )

        -- Show alert if no other windows to cycle to
        if #windowsOnScreen <= 1 then
            hs.alert.show("only me here", currentScreen)
            return
        end

        -- Find next window in the list
        local currentIndex = hs.fnutils.indexOf(windowsOnScreen, currentWin) or 0
        local nextIndex = (currentIndex % #windowsOnScreen) + 1
        windowsOnScreen[nextIndex]:focus()
    end

    -- Cycle through windows of current app on current screen
    local function cycleAppWindowsOnCurrentScreen()
        local currentWin = hs.window.focusedWindow()
        if not currentWin then return end

        local currentApp = currentWin:application()
        local currentScreen = currentWin:screen()

        local appWindowsOnScreen = hs.fnutils.filter(
            currentApp:allWindows(),
            function(win)
                return win:screen() == currentScreen and win:isStandard()
            end
        )

        if #appWindowsOnScreen > 1 then
            local currentIndex = hs.fnutils.indexOf(appWindowsOnScreen, currentWin)
            local nextIndex = (currentIndex % #appWindowsOnScreen) + 1
            appWindowsOnScreen[nextIndex]:focus()
        end
    end

    -- Option + 1 = cycle through all windows on current screen
    hs.hotkey.bind({ "alt" }, "1", cycleWindowsOnCurrentScreen)
  '';
}

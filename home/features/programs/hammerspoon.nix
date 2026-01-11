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

    local function moveMouseToScreen(scr, zone)
        local f = scr:fullFrame()
        local x = f.x + f.w / 2
        local y
        if zone == "top" then
            y = f.y + f.h / 4
        elseif zone == "bottom" then
            y = f.y + f.h * 3 / 4
        else
            y = f.y + f.h / 2
        end
        hs.mouse.setAbsolutePosition({ x = x, y = y })
        local zoneLabel = zone and (" (" .. zone .. ")") or ""
        hs.alert.show("Mouse → " .. scr:name() .. zoneLabel)
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

    local function gotoScreen(key, zone)
        local scr = findScreenByKey(key)
        if not scr then
            hs.alert.show("Screen not found: " .. key)
            print("Available screens: " .. allScreenNames())
            return
        end
        moveMouseToScreen(scr, zone)
    end

    local function moveCursorToWindow(win)
        local frame = win:frame()
        hs.mouse.setAbsolutePosition({
            x = frame.x + frame.w / 2,
            y = frame.y + frame.h / 2
        })
    end

    local function moveWindowToScreen(scr, zone)
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

        -- If zone is specified (top/bottom), always move to that zone
        if zone == "top" or zone == "bottom" then
            win:moveToScreen(scr)
            if zone == "top" then
                win:moveToUnit({x=0, y=0, w=1, h=0.5})
                hs.alert.show("Window → " .. scr:name() .. " (top)")
            else
                win:moveToUnit({x=0, y=0.5, w=1, h=0.5})
                hs.alert.show("Window → " .. scr:name() .. " (bottom)")
            end
            moveCursorToWindow(win)
            return
        end

        -- No zone: use cycling behavior for full-screen displays
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
            -- Move to new screen, preserving size
            win:moveToScreen(scr, true, true)  -- noResize=true, ensureInScreenBounds=true
            hs.alert.show("Window → " .. scr:name())
        end

        -- Move cursor to center of window after moving it
        moveCursorToWindow(win)
    end

    local function moveWindowTo(key, zone)
        local scr = findScreenByKey(key)
        if not scr then
            hs.alert.show("Screen not found: " .. key)
            print("Available screens: " .. allScreenNames())
            return
        end
        moveWindowToScreen(scr, zone)
    end

    -- ---------- Named Screen Mappings ----------
    -- Each entry: { screen = "name", zone = "top"/"bottom"/nil }
    local targetByKey = {
        q = { screen = "LG FHD", zone = "top" },       -- Option+Q → LG FHD top
        a = { screen = "LG FHD", zone = "bottom" },    -- Option+A → LG FHD bottom
        w = { screen = "ULTRAGEAR", zone = nil },      -- Option+W → ULTRAGEAR (main)
        e = { screen = "DELL", zone = "top" },         -- Option+E → DELL top
        d = { screen = "DELL", zone = "bottom" },      -- Option+D → DELL bottom
        s = { screen = ":ipad", zone = nil },          -- Option+S → iPad (Sidecar)
    }

    -- ---------- Named Screen Hotkeys ----------
    -- Option + key = move mouse to screen/zone
    for key, target in pairs(targetByKey) do
        hs.hotkey.bind({ "alt" }, key, function() gotoScreen(target.screen, target.zone) end)
    end

    -- Ctrl + Option + key = move current window to screen/zone
    for key, target in pairs(targetByKey) do
        hs.hotkey.bind({ "ctrl", "alt" }, key, function() moveWindowTo(target.screen, target.zone) end)
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

    -- ---------- App Launcher Helpers ----------
    -- Launch app and position it on a specific screen with a specific size
    local function launchAndPosition(appName, screenKey, position)
        -- position: {x, y, w, h} in unit rect (0-1)
        local targetScreen = findScreenByKey(screenKey)
        if not targetScreen then
            hs.alert.show("Screen not found: " .. screenKey)
            return
        end

        local function positionWindow(win)
            if win then
                win:moveToScreen(targetScreen)
                win:moveToUnit(position)
            end
        end

        -- Launch/focus the app
        hs.application.launchOrFocus(appName)

        -- Simple approach: wait a bit, then position the focused window
        hs.timer.doAfter(1.0, function()
            local win = hs.window.focusedWindow()
            if win then
                positionWindow(win)
                -- Move mouse to center of window
                local frame = win:frame()
                hs.mouse.setAbsolutePosition({
                    x = frame.x + frame.w / 2,
                    y = frame.y + frame.h / 2
                })
            end
        end)
    end

    -- Cursor: launch on ULTRAGEAR (main), right 70%
    function launchCursor()
        launchAndPosition("Cursor", "ULTRAGEAR", {x=0.3, y=0, w=0.7, h=1})
    end

    -- ---------- URL Handler for CLI integration ----------
    hs.urlevent.bind("launchCursor", function(eventName, params)
        launchCursor()
    end)
  '';
}

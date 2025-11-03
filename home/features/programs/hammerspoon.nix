{ pkgs, user, ... }:
{
  home.file.".hammerspoon/init.lua".text = ''
    -- Sortér skærme efter placering (venstre->højre, så op->ned)
    local function sortedScreens()
        local list = hs.screen.allScreens()
        table.sort(list, function(a, b)
            local fa, fb = a:fullFrame(), b:fullFrame()
            if fa.x == fb.x then return fa.y < fb.y end
            return fa.x < fb.x
        end)
        return list
    end

    -- Flyt musen til midten af skærm #index i venstre->højre rækkefølge
    local function moveMouseToIndex(index)
        local screens = sortedScreens()
        local s = screens[index]
        if not s then return hs.alert.show("Ingen skærm " .. index) end
        local f = s:fullFrame()
        hs.mouse.setAbsolutePosition({ x = f.x + f.w / 2, y = f.y + f.h / 2 })
        -- hs.alert.show(("Mus til skærm %d (%s)"):format(index, s:name()))
    end

    -- Cmd + 1..5 = skærm 1..5 (venstre -> højre)
    for i = 1, 5 do
        hs.hotkey.bind({ "cmd" }, tostring(i), function() moveMouseToIndex(i) end)
    end

    -- (Valgfrit) Hop til skærmen til venstre/højre for musen
    hs.hotkey.bind({ "cmd", "alt" }, "left", function()
        local screens = sortedScreens()
        local cur = hs.mouse.getCurrentScreen()
        local idx
        for i, s in ipairs(screens) do
            if s == cur then
                idx = i
                break
            end
        end
        if idx and idx > 1 then moveMouseToIndex(idx - 1) end
    end)

    hs.hotkey.bind({ "cmd", "alt" }, "right", function()
        local screens = sortedScreens()
        local cur = hs.mouse.getCurrentScreen()
        local idx
        for i, s in ipairs(screens) do
            if s == cur then
                idx = i
                break
            end
        end
        if idx and idx < #screens then moveMouseToIndex(idx + 1) end
    end)

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

    local function gotoScreen(key)
        local scr = findScreenByKey(key)
        if not scr then
            hs.alert.show("Screen not found: " .. key)
            print("Available screens: " .. allScreenNames())
            return
        end
        moveMouseToScreen(scr)
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

    -- ---------- Named Screen Hotkeys (Option + key) ----------
    for key, target in pairs(targetByKey) do
        hs.hotkey.bind({ "alt" }, key, function() gotoScreen(target) end)
    end

    -- (Optional) Show all detected screen names with Option+Shift+S
    hs.hotkey.bind({ "alt", "shift" }, "s", function()
        hs.alert.show("Screens: " .. allScreenNames())
        print("Screens: " .. allScreenNames())
    end)
  '';
}

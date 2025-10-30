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
  '';
}

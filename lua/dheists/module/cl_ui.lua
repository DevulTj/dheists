--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

function surface.DrawCuteRect(x, y, w, h, gasp, alpha)
    if (not gasp) then
        gasp = 4
    end
    if (! alpha) then
        alpha = 100
    end

    surface.SetDrawColor(0, 0, 0, alpha)
    surface.DrawRect(x, y, w, h)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawRect(x, y, 4 * gasp, gasp)
    surface.DrawRect(x + w - 4 * gasp, y, 4 * gasp, gasp)
    surface.DrawRect(x, y + h - gasp, 4 * gasp, gasp)
    surface.DrawRect(x + w - 4 * gasp, y + h - gasp, 4 * gasp, gasp)
    surface.DrawRect(x, y + gasp, gasp, 4 * gasp)
    surface.DrawRect(x + w - gasp, y + gasp, gasp, 4 * gasp - gasp)
    surface.DrawRect(x, y + gasp + h - 4 * gasp - gasp, gasp, 4 * gasp - gasp)
    surface.DrawRect(x + w - gasp, y + gasp + h - 4 * gasp - gasp, gasp, 4 * gasp - gasp)
end

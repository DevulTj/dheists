--[[
    © 2017 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

hook.Add( "InitPostEntity", dHeists.IDENTIFIER .. "cache", function()
    dHeists.CURRENT_LEVEL = game.GetMap()
end )

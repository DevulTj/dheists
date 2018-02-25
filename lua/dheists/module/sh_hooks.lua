--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

hook.Add( "InitPostEntity", dHeists.IDENTIFIER .. "cache", function()
    dHeists.CURRENT_LEVEL = game.GetMap()
end )


hook.Add( "OnReloaded", dHeists.IDENTIFIER .. "reload", function()
    hook.Run( "dHeists.zones.registerZones" )
    hook.Run( "dHeists.robbing.registerEnt" )
    hook.Run( "dHeists.loot.registerLoot" )
    hook.Run( "dHeists.ent.registerEnts" )
end )
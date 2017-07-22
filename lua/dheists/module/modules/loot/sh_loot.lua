--[[
    © 2017 devultj.co, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

dHeists.loot = dHeists.loot or {}
dHeists.loot.list = {}

function dHeists.loot.registerLoot( lootName, data )
    if not lootName then return end

    data.name = lootName
    dHeists.loot.list[ lootName ] = data
end

function dHeists.loot.getLoot( lootName )
    return dHeists.loot.list[ lootName ]
end

hook.Run( "dHeists.loot.registerLoot" )

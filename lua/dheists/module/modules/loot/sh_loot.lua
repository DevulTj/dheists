--[[
    © 2021 Tony Ferguson, do not share, re-distribute or modify

    without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

dHeists.loot = dHeists.loot or {}
dHeists.loot.list = {}

function dHeists.loot:registerLoot( lootName, data )
    if not lootName then return end

    data.name = lootName
    dHeists.loot.list[ lootName ] = data

    hook.Run( "dHeists.loot.registerLoot", lootName, data )
end

function dHeists.loot.getLoot( lootName )
    return dHeists.loot.list[ lootName ]
end

hook.Run( "dHeists.loot.registerLoots" )

-- Include configuration for loot
frile.includeFile( "dheists/config/config_entities/sh_loot.lua" )



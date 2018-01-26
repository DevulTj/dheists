--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.npc.list = {}
dHeists.npc.locations = {}

function dHeists.npc.create( name, data )
    local npc = data
    data.name = name

    dHeists.npc.list[ name ] = npc
end

function dHeists.npc.addLocation( map, name, data )
    local location = data
    location.name = name

    dHeists.npc.locations[ map ] = dHeists.npc.locations[ map ] or {}
    dHeists.npc.locations[ map ][ name ] = location
end

function dHeists.npc.getNPCLocations( name )
    local curLevel = game.GetMap()
    return dHeists.npc.locations[ curLevel ] and dHeists.npc.locations[ curLevel ][ name ]
end

hook.Call( "dHeists.npc.registerNPCs" )

-- Include configuration for npcs
frile.includeFile( "dheists/config/config_entities/sh_npcs.lua" )
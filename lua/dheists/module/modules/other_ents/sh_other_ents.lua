--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }}
]]

dHeists.ent.list = {}
dHeists.ent.locations = {}

function dHeists.ent.create( name, data )
    local ent = data
    data.name = name

    dHeists.ent.list[ name ] = ent
end

function dHeists.ent.addLocation( map, name, data )
    local location = data
    location.name = name

    dHeists.ent.locations[ map ] = dHeists.ent.locations[ map ] or {}
    dHeists.ent.locations[ map ][ name ] = location
end

function dHeists.ent.getEntLocations( name )
    local curLevel = game.GetMap()
    return dHeists.ent.locations[ curLevel ] and dHeists.ent.locations[ curLevel ][ name ]
end

hook.Call( "dHeists.ent.registerEnts" )

-- Include configuration for ents
frile.includeFile( "dheists/config/config_entities/sh_other_ents.lua" )
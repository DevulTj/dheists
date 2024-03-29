--[[
    © 2021 Tony Ferguson, do not share, re-distribute or modify

    without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

dHeists.zones = dHeists.zones or {}
dHeists.zones.list = {}

function dHeists.zones:registerZone( map, zoneName, data )
    if not zoneName then return end

    data.name = zoneName
    self.list[ map ] = self.list[ map ] or {}
    self.list[ map ][ zoneName ] = data

    hook.Run( "dHeists.zones.registerZone", map, zoneName, data )
end

function dHeists.zones:getZone( zoneName )
    return self.list[ dHeists.CURRENT_LEVEL or game.GetMap() ][ zoneName ]
end

function dHeists.zones:getZones( map )
    return self.list[ map or dHeists.CURRENT_LEVEL or game.GetMap() ]
end

hook.Run( "dHeists.zones.registerZones" )

-- Include configuration for zones
frile.includeFile( "dheists/config/config_entities/sh_zones.lua" )

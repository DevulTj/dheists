--[[
    © 2017 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

dHeists.zones = dHeists.zones or {}
dHeists.zones.list = {}

function dHeists.zones:registerZone( zoneName, data )
    if not zoneName then return end

    data.name = zoneName
    dHeists.zones.list[ zoneName ] = data
end

function dHeists.zones.getZone( zoneName )
    return dHeists.zones.list[ zoneName ]
end

hook.Run( "dHeists.zones.registerZones" )

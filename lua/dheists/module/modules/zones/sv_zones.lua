--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

function dHeists.zones:spawnZones()
    self.zones = self.zones or {}

    -- Autorefresh support
    for zoneName, zone in pairs( self.zones ) do
        -- Clear objects and the zone itself
        zone:destroyEntities()
        self.zones[ zoneName ] = nil
    end

    for zoneName, typeInfo in pairs( self:getZones() or {} ) do
        -- Create zone object
        local zone = HeistZone:new( typeInfo )
        -- Register it in the zones object table
        self.zones[ zoneName ] = zone

        dHeists.print( "Spawning " .. ( tostring( zone ) ) )

        -- Spawn zone objects
        zone:spawnEntities()
    end
end

hook.Add( "InitPostEntity", "dHeists.zones", function()
    dHeists.zones:spawnZones()
end )

concommand.Add( "dheists_reload_zones", function( player )
    dHeists.zones:spawnZones()
end )

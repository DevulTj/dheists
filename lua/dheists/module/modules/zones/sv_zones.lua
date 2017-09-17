--[[
    © 2017 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

function dHeists.zones:spawnZones()
    self.zones = self.zones or {}

    -- Autorefresh support
    for sName, zZone in pairs( self.zones ) do
        -- Clear objects and the zone itself
        zZone:destroyEntities()
        self.zones[ sName ] = nil
    end

    for sName, tData in pairs( self.list ) do
        -- Create zone object
        local zHeistZone = HeistZone:new( tData )
        -- Register it in the zones object table
        self.zones[ sName ] = zHeistZone

        dHeists.print( "Spawning " .. ( tostring( zHeistZone ) ) )

        -- Spawn zone objects
        zHeistZone:spawnEntities()
    end
end

hook.Add( "InitPostEntity", "dHeists.zones", function()
    dHeists.zones:spawnZones()
end )

concommand.Add( "dheists_reload_zones", function( player )
    if not player:IsSuperAdmin() then return end

    dHeists.zones:spawnZones()
end )

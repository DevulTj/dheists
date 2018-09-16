--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

function dHeists.zones:spawnZones()
    self.zones = self.zones or {}

    -- Autorefresh support
    for zoneName, zone in pairs( self.zones ) do
        -- Clear objects and the zone itself
        zone:destroyEntities()
        zone:spawnEntities()
    end

    for zoneName, typeInfo in pairs( self:getZones() or {} ) do
        if self.zones[ zoneName ] then continue end

        -- Create zone object
        local zone = HeistZone:new( typeInfo )
        zone:setName( zoneName )
        -- Register it in the zones object table
        self.zones[ zoneName ] = zone

        dHeists.print( "Spawning " .. tostring( zone ) )

        -- Combine the categories to get the team list
        zone:combineCategores()

        -- Spawn zone objects
        zone:spawnEntities()
    end
end

hook.Add( "dHeists.InitPostEntity", "dHeists.zones", function()
    dHeists.zones:spawnZones()
end )

concommand.Add( "dheists_reload_zones", function( player )
    local function hasAccessCallback( hasAccess )
        if not hasAccess then return end

        if IsValid( player ) then player:dHeistsHint( dL "reloaded_zones", NOTIFY_SUCCESS ) end

        dHeists.zones:spawnZones()
    end

    -- If called by console, they `always` have access.
    if not IsValid( player ) then
        hasAccessCallback( true )

        return
    end

    -- To prevent duplicate code, let's check for non-console units.
    CAMI.PlayerHasAccess( player, dHeists.privileges.RELOAD_ZONES, hasAccessCallback )
end )


function dHeists.zones:createDynamicZone( zoneName, origin )
    local zone = HeistZone:new( {
        origin = origin,
        name = zoneName,
        minJobOnlineForRobbery = dHeists.config.minJobOnlineForRobbery or 0,
        jobCategories = dHeists.config.defaultCopCategories,
        jobNames = dHeists.config.defaultCopJobs,
        dynamic = true
    } )

    -- Register it in the zones object table
    self.zones[ zoneName ] = zone

    dHeists.print( "Created dynamic zone " .. zoneName .. " (" .. tostring( zone ) .. ")" )

    return zone
end


function dHeists.zones:createZone( player, zoneName, origin )
    CAMI.PlayerHasAccess( player, dHeists.privileges.EDIT_ZONES, function( hasAccess )
        if not hasAccess then player:dHeistsHint( dL "no_access", NOTIFY_ERROR ) return end

        dHeists.db.createZone( player, zoneName, function()
            self:createDynamicZone( zoneName, origin )
        end )
    end )
end

function dHeists.zones:deleteDynamicZone( player, zoneName )
    local zone = self.zones[ zoneName ]
    if not zone then return end

    dHeists.db.deleteZone( zoneName, function()
        player:dHeistsHint( dL "deleted_zone", NOTIFY_SUCCESS )

        zone:destroyEntities()
        self.zones[ zoneName ] = nil
    end )
end

function dHeists.zones:gatherZoneNames()
    local tbl = {}
    for zoneName, zone in pairs( self.zones ) do
        tbl[ zoneName ] = zone.dynamic or false
    end

    return tbl
end

hook.Add( "PlayerSpawnedSENT", "dHeists.zones", function( pPlayer, eEntity )
    if pPlayer:getDevString( "zoneEditing" ) == "" then
        -- Flags to detect if it is used for zone creation
        if eEntity.DHeists and eEntity._Entity then
            SafeRemoveEntity( eEntity )

            pPlayer:dHeistsHint( "edit_zone_spawn_entity", NOTIFY_ERROR )
        end

        return
    end
end )
--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

dHeists.db = dHeists.db or {}

hook.Add( "dHeistsDBInitialized", "dHeists.zones", function()
    dHeistsDB.query( [[
        CREATE TABLE IF NOT EXISTS dheists_zones (
            zone_name VARCHAR( 66 ) NOT NULL PRIMARY KEY,
            origin_x BIGINT NOT NULL,
            origin_y BIGINT NOT NULL,
            origin_z BIGINT NOT NULL,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
    ]] )

    dHeistsDB.query( [[
        CREATE TABLE IF NOT EXISTS dheists_zones_entities (
            zone_name VARCHAR( 66 ) NOT NULL,
            entity TEXT NOT NULL,
            entity_class TEXT NOT NULL,

            pos_x BIGINT NOT NULL,
            pos_y BIGINT NOT NULL,
            pos_z BIGINT NOT NULL,

            ang_p BIGINT NOT NULL,
            ang_y BIGINT NOT NULL,
            ang_r BIGINT NOT NULL,
            
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
    ]] )
end )


local ceil = math.ceil

local zoneInsertSQL = [[INSERT INTO dheists_zones (zone_name, origin_x, origin_y, origin_z) VALUES (%s, %i, %i, %i)]]
local function createZone( player, zoneName, origin, callback )
    if not isvector( origin ) then return end
    if not tonumber( origin.x ) and not tonumber( origin.y ) and not tonumber( origin.z ) then return end

    dHeistsDB.query( zoneInsertSQL:format( dHeistsDB.SQLStr( zoneName ), ceil( origin.x ), ceil( origin.y ), ceil( origin.z ) ), function( data )
        player:dHeistsNotify( dL "zone_created" )

        if callback then callback() end
    end, function( err )
        player:dHeistsNotify( dL "zone_duplicate", NOTIFY_ERROR )
    end )
end

function dHeists.db.createZone( player, zoneName, callback )
    CAMI.PlayerHasAccess( player, dHeists.privileges.RELOAD_ENTS, function( hasAccess )
        if not hasAccess then player:dHeistsNotify( dL "no_access", NOTIFY_ERROR ) return end

        createZone( player, zoneName, player:GetPos(), callback )
    end )
end
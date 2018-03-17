--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com) - {{ user_id }}
]]

dHeists.db = dHeists.db or {}

function dHeists.db.zonesDBInit()
    dHeistsDB.begin()

    dHeistsDB.queueQuery( [[
        CREATE TABLE IF NOT EXISTS dheists_zones (
            zone_name VARCHAR( 66 ) NOT NULL PRIMARY KEY,
            origin_x BIGINT NOT NULL,
            origin_y BIGINT NOT NULL,
            origin_z BIGINT NOT NULL,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
    ]] )

    local SQLITE = not dHeistsDB.isMySQL()

    if SQLITE then
        dHeistsDB.queueQuery( [[
            CREATE TABLE IF NOT EXISTS dheists_zones_entities (
                id INTEGER PRIMARY KEY,
                zone_name VARCHAR( 66 ) NOT NULL,
                entity TEXT NOT NULL,
                entity_class TEXT NOT NULL,

                pos_x BIGINT NOT NULL,
                pos_y BIGINT NOT NULL,
                pos_z BIGINT NOT NULL,

                ang_p BIGINT NOT NULL,
                ang_y BIGINT NOT NULL,
                ang_r BIGINT NOT NULL
            )
        ]], nil, function( err ) print( err ) end )
    else
        dHeistsDB.queueQuery( [[
            CREATE TABLE IF NOT EXISTS dheists_zones_entities (
                id INTEGER AUTO_INCREMENT PRIMARY KEY,
                zone_name VARCHAR( 66 ) NOT NULL,
                entity TEXT NOT NULL,
                entity_class TEXT NOT NULL,

                pos_x BIGINT NOT NULL,
                pos_y BIGINT NOT NULL,
                pos_z BIGINT NOT NULL,

                ang_p BIGINT NOT NULL,
                ang_y BIGINT NOT NULL,
                ang_r BIGINT NOT NULL
            )
        ]], nil, function( err ) print( err ) end )
    end

    dHeists.db.loadZones()

    dHeistsDB.commit()
end

hook.Add( "dHeistsDBInitialized", "dHeists.zones", dHeists.db.zonesDBInit )


local ceil = math.ceil

local zoneInsertSQL = [[INSERT INTO dheists_zones (zone_name, origin_x, origin_y, origin_z) VALUES (%s, %i, %i, %i)]]
local function createZone( player, zoneName, origin, callback )
    if not isvector( origin ) then return end
    if not tonumber( origin.x ) and not tonumber( origin.y ) and not tonumber( origin.z ) then return end

    dHeistsDB.query( zoneInsertSQL:format( dHeistsDB.SQLStr( zoneName ), ceil( origin.x ), ceil( origin.y ), ceil( origin.z ) ), function( data )
        player:dHeistsHint( dL "zone_created" )

        if callback then callback() end
    end, function( err )
        player:dHeistsHint( dL "zone_duplicate", NOTIFY_ERROR )
    end )
end

function dHeists.db.createZone( player, zoneName, callback )
    CAMI.PlayerHasAccess( player, dHeists.privileges.EDIT_ZONES, function( hasAccess )
        if not hasAccess then player:dHeistsHint( dL "no_access", NOTIFY_ERROR ) return end

        createZone( player, zoneName, player:GetPos(), callback )
    end )
end

local addEntitySQL = [[INSERT INTO dheists_zones_entities (id, zone_name, entity, entity_class, pos_x, pos_y, pos_z, ang_p, ang_y, ang_r) 
                       VALUES(NULL, %s, %s, %s, %i, %i, %i, %i, %i, %i)]]

function dHeists.db.addEntityToZone( zoneName, entity, callback )

    local entityType = entity._Entity
    if not entityType then print( "No entity type aaaa" ) return end

    local entPos = entity:GetPos()
    local entAng = entity:GetAngles()

    dHeistsDB.query( addEntitySQL:format(
        dHeistsDB.SQLStr( zoneName ),
        dHeistsDB.SQLStr( entityType ),
        dHeistsDB.SQLStr( entity.GetEntityType and entity:GetEntityType() or entity:GetClass() ),
        entPos.x, entPos.y, entPos.z,
        entAng.p, entAng.y, entAng.r
    ), callback, function( err )
        print("falied to add entity to zone", err)
    end )
end

local modifyEntitySQL = [[UPDATE dheists_zones_entities SET 
                            pos_x = %i, pos_y = %i, pos_z = %i, ang_p = %i, ang_y = %i, ang_r = %i 
                            WHERE id = %i
                        ]]

function dHeists.db.modifyEntityToZone( zoneName, entity, callback )
    local creationId = entity:getDevInt( "creationId" )
    if not creationId or creationId == 0 then return end

    local entPos = entity:GetPos()
    local entAng = entity:GetAngles()

    dHeistsDB.query( modifyEntitySQL:format(
        entPos.x, entPos.y, entPos.z,
        entAng.p, entAng.y, entAng.r,
        creationId
    ), callback )
end

function dHeists.db.loadZones()
    dHeistsDB.queueQuery( [[
        SELECT zone_name, origin_x, origin_y, origin_z FROM dheists_zones
    ]], function( data )
        if not data then return end

        for _, zoneInfo in pairs( data ) do
            local zoneName = zoneInfo.zone_name
            local zone = dHeists.zones:createDynamicZone( zoneName, Vector( zoneInfo.origin_x, zoneInfo.origin_y, zoneInfo.origin_z ) )

            dHeists.db.getZoneEntities( zoneName, function( entities )
                for _, entInfo in pairs( entities or {} ) do
                    zone[ entInfo.entity ] = zone[ entInfo.entity ] or {}

                    table.insert( zone[ entInfo.entity ], {
                        type = entInfo.entity_class,
                        pos = Vector( entInfo.pos_x, entInfo.pos_y, entInfo.pos_z ),
                        ang = Angle( entInfo.ang_p, entInfo.ang_y, entInfo.ang_r ),
                        creationId = entInfo.id
                    } )
                end

                zone:spawnEntities()
            end )
        end
    end )
end

local getZoneEntitiesSQL = [[SELECT * FROM dheists_zones_entities WHERE zone_name = %s]]
function dHeists.db.getZoneEntities( zoneName, callback )
    dHeistsDB.query( getZoneEntitiesSQL:format( dHeistsDB.SQLStr( zoneName ) ), callback, function( err ) print( err ) end )
end

local deleteEntitySQL = [[DELETE FROM dheists_zones_entities WHERE id = %i]]
function dHeists.db.deleteEntity( creationId, callback )
    dHeistsDB.query( deleteEntitySQL:format( creationId ), callback )
end

local deleteZoneEntitiesSQL = [[DELETE FROM dheists_zones WHERE zone_name = %s]]
local deleteZoneSQL = [[DELETE FROM dheists_zones_entities WHERE zone_name = %s]]
function dHeists.db.deleteZone( zoneName, callback )
    dHeistsDB.begin()
        zoneName = dHeistsDB.SQLStr( zoneName )

        dHeistsDB.queueQuery( deleteZoneSQL:format( zoneName ) )
        dHeistsDB.queueQuery( deleteZoneEntitiesSQL:format( zoneName ) )
    dHeistsDB.commit( callback )
end
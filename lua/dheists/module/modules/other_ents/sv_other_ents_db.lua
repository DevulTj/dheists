--[[
    © 2021 Tony Ferguson, do not share, re-distribute or modify

    without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

dHeists.db = dHeists.db or {}

function dHeists.db.otherEntsDBInit()
    dHeistsDB.begin()
        local SQLITE = not dHeistsDB.isMySQL()
        if SQLITE then
            dHeistsDB.queueQuery( [[
                CREATE TABLE IF NOT EXISTS dheists_other_entities (
                    id INTEGER PRIMARY KEY,
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
                CREATE TABLE IF NOT EXISTS dheists_other_entities (
                    id INTEGER AUTO_INCREMENT PRIMARY KEY,
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
        dHeists.db.loadOtherEntities()
    dHeistsDB.commit()
end

hook.Add( "dHeistsDBInitialized", "dHeists.otherEnts", dHeists.db.otherEntsDBInit )

local addEntitySQL = [[INSERT INTO dheists_other_entities (id, entity_class, pos_x, pos_y, pos_z, ang_p, ang_y, ang_r)
                       VALUES(NULL, %s, %i, %i, %i, %i, %i, %i)]]

function dHeists.db.insertOtherEntity( entity, callback )
    local className = entity:getDevString( "entityType", "" )
    if not className or className == "" then return end

    local entPos = entity:GetPos()
    local entAng = entity:GetAngles()

    dHeistsDB.query( addEntitySQL:format(
        dHeistsDB.SQLStr( className ),
        entPos.x, entPos.y, entPos.z,
        entAng.p, entAng.y, entAng.r
    ), callback, function( err )
        print( "falied to insert other entity", err )
    end )
end

local modifyEntitySQL = [[UPDATE dheists_other_entities SET
                            pos_x = %i, pos_y = %i, pos_z = %i, ang_p = %i, ang_y = %i, ang_r = %i
                            WHERE id = %i
                        ]]

function dHeists.db.modifyOtherEntity( entity, callback )
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

function dHeists.db.loadOtherEntities()
    dHeists.print( "Attempting to load other entities" )

    dHeistsDB.queueQuery( [[
        SELECT id, entity_class, pos_x, pos_y, pos_z, ang_p, ang_y, ang_r FROM dheists_other_entities
    ]], function( data )
        if not data then return end

        for _, entityInfo in pairs( data ) do
            local entData = dHeists.ent.list[ entityInfo.entity_class ]
            if not entData then continue end

            local entity = dHeists.spawnEnt( entData, Vector( entityInfo.pos_x, entityInfo.pos_y, entityInfo.pos_z ), Angle( entityInfo.ang_p, entityInfo.ang_y, entityInfo.ang_r ) )
            entity:setDevInt( "creationId", entityInfo.id )

            dHeists.print( "Spawned other entity " .. entityInfo.entity_class )
        end
    end )
end

local deleteEntitySQL = [[DELETE FROM dheists_other_entities WHERE id = %i]]
function dHeists.db.deleteOtherEntity( creationId, callback )
    dHeistsDB.query( deleteEntitySQL:format( creationId ), callback )
end


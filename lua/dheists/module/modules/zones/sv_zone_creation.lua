--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

util.AddNetworkString( "dHeists.OpenZoneCreator" )
util.AddNetworkString( "dHeists.CloseZoneCreator" )
util.AddNetworkString( "dHeists.CreateZone" )
util.AddNetworkString( "dHeists.EditZone" )
util.AddNetworkString( "dHeists.StopEditZone" )
util.AddNetworkString( "dHeists.SaveZone" )

dHeists.zones = dHeists.zones or {}

function dHeists.zones:saveNewEntsToZone( zoneId, newEntities, callback )
    local zone
    for zoneName, _zone in pairs( self.zones ) do
        if _zone:getId() == zoneId then
            zone = _zone
            break
        end
    end

    if not zone then return end

    print( "Listing new saved entities for zone id " .. zoneId )

    local lastId = #newEntities

    local function checkForEnd( id, count )
        if ( id == lastId or count == 0 ) and callback then print("Reached the end for saveNew") callback( zone ) end
    end

    local count = 0

    if lastId == 0 then
        if callback then callback( zone ) end

        return
    end

    for id, entity in pairs( newEntities ) do
        count = count + 1

        if not IsValid( entity ) then checkForEnd( id, count ) continue end

        dHeists.db.addEntityToZone( zone:getName(), entity, function( data, lastInsert )
            if data ~= "ERROR" then
                print( "Saved new entity for zone id " .. zoneId .. " - " .. tostring( entity ) )

                local entType = entity._Entity
                if not entType then debug.Trace() return end

                zone[ entType ] = zone[ entType ] or {}

                table.insert( zone[ entType ], {
                    type = entity.GetEntityType and entity:GetEntityType() or entity:GetClass(),
                    pos = entity:GetPos(),
                    ang = entity:GetAngles(),
                    creationId = lastInsert
                } )
            end

            checkForEnd( id, count )
        end )
    end
end

function dHeists.zones:saveModifiedEntsToZone( zoneId, modifiedEnts, callback )
    local zone
    for zoneName, _zone in pairs( self.zones ) do
        if _zone:getId() == zoneId then
            zone = _zone
            break
        end
    end

    if not zone then return end

    print( "Listing modified entities for zone id " .. zoneId )

    local lastId = #modifiedEnts

    local function checkForEnd( id, count )
        if ( id == lastId or count == 0 ) and callback then print("Reached the end for saveModified") callback( zone ) end
    end

    -- If there's no entities, just skip this process.
    if lastId == 0 then
        if callback then print("No entities, so skipping") callback( zone ) end

        return
    end

    local count = 0
    for id, entity in pairs( modifiedEnts ) do
        -- @TODO: edit each entity via SQL

        if not IsValid( entity ) then continue end
        count = count + 1
        
        print( entity )
        dHeists.db.modifyEntityToZone( zone:getName(), entity, function( data )
            if data ~= "ERROR" then
                print( "Saved modified entity for zone id " .. zoneId .. " - " .. tostring( entity ) )

                local entType = entity._Entity
                zone[ entType ] = zone[ entType ] or {}

                local creationId = entity:getDevInt( "creationId" )

                for entId, entData in pairs( zone[ entType ] ) do
                    print(type(creationId), type(entData.creationId))
                    if creationId == tonumber( entData.creationId ) then
                        print( "Replacing information for entity " .. entId .. " ( " .. entData.type .. " | " .. entData.creationId .. ")" )
                        zone[ entType ][ entId ] = {
                            type = entData.type,
                            pos = entity:GetPos(),
                            ang = entity:GetAngles(),
                            creationId = entData.creationId
                        }

                        break
                    end
                end

                checkForEnd( id, count )
            end
        end )
    end
end

function dHeists.zones:saveZone( zoneId, newEntities, modifiedEnts )
    self:saveNewEntsToZone( zoneId, newEntities, function()
        self:saveModifiedEntsToZone( zoneId, modifiedEnts, function( zone )

            for k, v in pairs( newEntities ) do SafeRemoveEntity( v ) end

            zone:destroyEntities()
            zone:spawnEntities()
        end )
    end )
end

--[[ Command to open zone creator ]]
dHeists.commands:add( {
    name = "zones",
    canDo = function( player, commandData )
        return true
    end,
    func = function( player, text, commandData )
        CAMI.PlayerHasAccess( player, dHeists.privileges.RELOAD_ENTS, function( hasAccess )
            if not hasAccess then player:dHeistsNotify( dL "no_access", NOTIFY_ERROR ) return end

            if player:getDevBool( "inZoneCreator" ) == true then
                player:dHeistsNotify( dL "already_in_zone_creator" )

                return
            end

            player:setDevBool( "inZoneCreator", true )

            net.Start( "dHeists.OpenZoneCreator" )
                net.WriteTable( dHeists.zones:gatherZoneNames() )
            net.Send( player )
        end )
    end
} )

--[[ Command to open zone editor ]]
dHeists.commands:add( {
    name = "editzone",
    canDo = function( player, commandData )
        return true
    end,
    func = function( player, text, commandData )
        CAMI.PlayerHasAccess( player, dHeists.privileges.RELOAD_ENTS, function( hasAccess )
            if not hasAccess then player:dHeistsNotify( dL "no_access", NOTIFY_ERROR ) return end
            if not text then return end

            if player:getDevString( "zoneEditing" ) ~= "" then
                player:dHeistsNotify( dL "already_in_zone_creator" )

                return
            end

            if istable( text ) then
                text = table.concat( text, " " )
            end

            local zone = dHeists.zones.zones[ text ]
            if not zone then return end

            player:setDevString( "zoneEditing", zone:getName() )

            net.Start( "dHeists.EditZone" )
                net.WriteUInt( zone:getId(), 16 )
            net.Send( player )
        end )
    end
} )

--[[ Command to stop zone editor ]]
dHeists.commands:add( {
    name = "stopeditzone",
    canDo = function( player, commandData )
        return true
    end,
    func = function( player, text, commandData )
        CAMI.PlayerHasAccess( player, dHeists.privileges.RELOAD_ENTS, function( hasAccess )
            if not hasAccess then player:dHeistsNotify( dL "no_access", NOTIFY_ERROR ) return end
            if not text then return end

            if player:getDevString( "zoneEditing" ) == "" then
                player:dHeistsNotify( dL "not_editing_zone" )

                return
            end

            player:setDevString( "zoneEditing", nil )

            net.Start( "dHeists.StopEditZone" )
            net.Send( player )
        end )
    end
} )

net.Receive( "dHeists.CloseZoneCreator", function( _, player )
    player:setDevBool( "inZoneCreator", false )
end )

net.Receive( "dHeists.CreateZone", function( _, player )
    local zoneName = net.ReadString()

    dHeists.zones:createZone( player, zoneName )
end )

net.Receive( "dHeists.SaveZone", function( _, player )
    local zoneId = net.ReadUInt( 16 )
    if not zoneId then return end

    local newEntities = net.ReadTable()
    local modifiedEntities = net.ReadTable()

    PrintTable( modifiedEntities )

    dHeists.zones:saveZone( zoneId, newEntities, modifiedEntities )

    player:setDevString( "zoneEditing", nil )

    net.Start( "dHeists.StopEditZone" )
    net.Send( player )
end )

function dHeists.zones:deleteEntityFromZone( zoneName, entity )
    local zone = self.zones[ zoneName ]
    if not zone then return end

    local creationId = entity:getDevInt( "creationId" )
    if not creationId or creationId == 0 then print("No creation ID, or is 0") return end

    local entType = entity._Entity

    dHeists.db.deleteEntity( creationId, function()
        for _id, data in pairs( zone[ entType ] or {} ) do
            if data.creationId == creationId then
                zone[ entType ][ _id ] = nil

                break
            end
        end
    end )
end
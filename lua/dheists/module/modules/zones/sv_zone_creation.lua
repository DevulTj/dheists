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
    player:setDevString( "zoneEditing", nil )

    net.Start( "dHeists.StopEditZone" )
    net.Send( player )
end )
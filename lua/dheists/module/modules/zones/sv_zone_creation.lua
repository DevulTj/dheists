--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

util.AddNetworkString( "dHeists.OpenZoneCreator" )
util.AddNetworkString( "dHeists.CloseZoneCreator" )
util.AddNetworkString( "dHeists.CreateZone" )
util.AddNetworkString( "dHeists.EditZone" )

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

net.Receive( "dHeists.CloseZoneCreator", function( _, player )
    player:setDevBool( "inZoneCreator", false )
end )

net.Receive( "dHeists.CreateZone", function( _, player )
    local zoneName = net.ReadString()

    dHeists.zones:createZone( player, zoneName )
end )

net.Receive( "dHeists.EditZone", function( _, player )
    local zoneName = net.ReadString()
end )
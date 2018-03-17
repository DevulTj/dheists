--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }}
]]

dHeists.waypoints = dHeists.waypoints or {}

util.AddNetworkString( "dHeists.waypoints.setLocation" )
util.AddNetworkString( "dHeists.waypoints.clearLocation" )

function dHeists.waypoints.setLocation( player, location, text )
    net.Start( "dHeists.waypoints.setLocation" )
        net.WriteVector( location )
        net.WriteString( text )
    net.Send( player )
end

function dHeists.waypoints.clearLocation( player )
    net.Start( "dHeists.waypoints.clearLocation" )
    net.Send( player )
end

local function setLootWaypoint( player )
    if dHeists.lootTrigger and IsValid( dHeists.lootTrigger ) then
        dHeists.waypoints.setLocation( player, dHeists.lootTrigger:GetPos(), "Deliver the loot to the drop-off point" )
    end
end

hook.Add( "dHeists.onAddLoot", "dHeists.waypoints", function( player, lootName, bag )
    if bag and #bag.lootItems > 0 then
        setLootWaypoint( player )
    end
end )

hook.Add( "dHeists.onDropBag", "dHeists.waypoints", function( player, noDrop, bagData )
    dHeists.waypoints.clearLocation( player )
end )

hook.Add( "dHeists.onPickUpBag", "dHeists.waypoints", function( player, bag )
    if bag and #bag.lootItems > 0 then
        setLootWaypoint( player )
    end
end )
--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.waypoints = dHeists.waypoints or {}

util.AddNetworkString( "dHeists.waypoints.setLocation" )

function dHeists.waypoints.setLocation( player, location, text )
    net.Start( "dHeists.waypoints.setLocation" )
        net.WriteVector( location )
        net.WriteString( text )
    net.Send( player )
end

hook.Add( "dHeists.onAddLoot", "dHeists.waypoints", function( player, lootName, bag )
    if #bag.lootItems > 0 and dHeists.lootTrigger and IsValid( dHeists.lootTrigger ) then
        dHeists.waypoints.setLocation( player, dHeists.lootTrigger:GetPos(), "Deliver the loot to the drop-off point" )
    end
end )
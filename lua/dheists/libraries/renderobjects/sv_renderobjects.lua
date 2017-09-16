--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

renderObjects = renderObjects or {}
renderObjects.objectList = renderObjects.objectList or {}

util.AddNetworkString( "renderObjects.loadObjects" )

util.AddNetworkString( "renderObjects.setObject" )
util.AddNetworkString( "renderObjects.clearObject" )

hook.Add( "PlayerInitialSpawn", "renderObjects.loadObjects", function( player )
	if #renderObjects:getObjects() < 1 then return end -- Ensure that there are existing objects to send to the client

	renderObjects:load( player )
end )

hook.Add( "PlayerDisconnected", "renderObjects.clearObjects", function( player )
	if not renderObjects:getPlayer( player ) then return end -- If the player doesn't have any objects, there is no need to clear

	renderObjects:clearPlayer( player )
end )

hook.Add( "renderObjects.setObject", "renderObjects.setObject", function( player, objectName )
	net.Start( "renderObjects.setObject" )
		net.WriteUInt( player:EntIndex(), 16 )
		net.WriteString( objectName )
	net.Broadcast()
end )

hook.Add( "renderObjects.clearObject", "renderObjects.clearObject", function( player, objectName )
	net.Start( "renderObjects.clearObject" )
		net.WriteUInt( player:EntIndex(), 16 )
		net.WriteString( objectName )
	net.Broadcast()
end )
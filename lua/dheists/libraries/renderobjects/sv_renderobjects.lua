--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify
	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

renderObjects = renderObjects or {}
renderObjects.objectList = renderObjects.objectList or {}

util.AddNetworkString( "renderObjects.loadObjects" )
util.AddNetworkString( "renderObjects.setObject" )
util.AddNetworkString( "renderObjects.setObjectsOfPlayer" )
util.AddNetworkString( "renderObjects.clearObject" )
util.AddNetworkString( "renderObjects.clearPlayer" )

hook.Add( "PlayerDisconnected", "renderObjects.clearObjects", function( player )
	if not renderObjects:getPlayer( player ) then return end -- If the player doesn't have any objects, there is no need to clear

	renderObjects:clearPlayer( player )
end )

hook.Add( "renderObjects.setObject", "renderObjects.setObject", function( player, objectName )
	net.Start( "renderObjects.setObject" )
		net.WriteEntity( player )
		net.WriteString( objectName )
	net.Broadcast()
end )

hook.Add( "renderObjects.setObjectsOfPlayer", "renderObjects.setObjectsOfPlayer", function( player, objects )
	net.Start( "renderObjects.setObjectsOfPlayer" )
		net.WriteEntity( player )
		net.WriteTable( objects )
	net.Broadcast()
end )

hook.Add( "renderObjects.clearObject", "renderObjects.clearObject", function( player, objectName )
	net.Start( "renderObjects.clearObject" )
		net.WriteEntity( player )
		net.WriteString( objectName )
	net.Broadcast()
end )

hook.Add( "renderObjects.clearPlayer", "renderObjects.clearPlayer", function( player, objectName )
	net.Start( "renderObjects.clearPlayer" )
		net.WriteEntity( player )
	net.Broadcast()
end )

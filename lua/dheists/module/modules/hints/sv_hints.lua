--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

dHeists.hints = dHeists.hints or {}

NOTIFY_SUCCESS = 10

util.AddNetworkString( "dHeists.hints.add" )

function dHeists.hints:hintPlayer( player, text, hintType, lifetime )
    if not text then return end

    net.Start( "dHeists.hints.add" )
        net.WriteString( text )
        net.WriteUInt( hintType or NOTIFY_GENERIC, 8 )
        net.WriteUInt( lifetime or 3, 4 )
    net.Send( player )
end

local PLAYER = FindMetaTable( "Player" )
function PLAYER:dHeistsHint( text, hintType, lifetime )
    return dHeists.hints:hintPlayer( self, text, hintType, lifetime )
end

--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.hints = dHeists.hints or {}

NOTIFY_SUCCESS = 10

util.AddNetworkString( "dHeists.hints.add" )

function dHeists.hints:hintPlayer( player, text, hintType, lifetime )
    if not text then return end

    net.Start( "dHeists.hints.add" )
        net.WriteString( text )
        net.WriteUInt( hintType, 8 )
        net.WriteUInt( lifetime or 3, 4 )
    net.Send( player )
end
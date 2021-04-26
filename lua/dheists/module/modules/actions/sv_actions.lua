--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

dHeists.actions = dHeists.actions or {}

util.AddNetworkString( "dHeists.actions.doAction" )
util.AddNetworkString( "dHeists.actions.finishAction" )

function dHeists.actions.doAction( player, length, callback, extraData )
    if player._dHeistsAction then player._dHeistsAction = nil end

    net.Start( "dHeists.actions.doAction" )
        net.WriteUInt( length, 8 )
        net.WriteTable( extraData or {} )
    net.Send( player )

    player._dHeistsAction = callback
end

function dHeists.actions.finishAction( player )
    if not player._dHeistsAction then return end

    player:_dHeistsAction()
end

net.Receive( "dHeists.actions.finishAction", function( len, player )
    dHeists.actions.finishAction( player )
end )

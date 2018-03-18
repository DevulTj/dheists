--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

function dHeists.addMoney( player, amount )
	return dHeists.config.addMoneyFunction and dHeists.config.addMoneyFunction( player, amount ) or player.addMoney and player:addMoney( amount )
end

local PLAYER = FindMetaTable( "Player" )

function PLAYER:dHeistsNotify( text, notificationType )
	return dHeists.gamemodes:notify( self, text, notificationType )
end
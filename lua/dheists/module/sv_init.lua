--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

function dHeists.addMoney( player, amount )
	return dHeists.config.addMoneyFunction and dHeists.config.addMoneyFunction( player, amount ) or player.addMoney and player:addMoney( amount )
end

local PLAYER = FindMetaTable( "Player" )

function PLAYER:dHeistsNotify( text, notificationType )
	return dHeists.gamemodes:notify( self, text, notificationType )
end


--[[ Register for tracking ]]

if not dHeists.config.disableServerTracking then
	fracker.registerTracker {
		id = dHeists.SCRIPT_ID,
		versionId = dHeists.VERSION,
		userId = "{{ user_id }}"
	}
end

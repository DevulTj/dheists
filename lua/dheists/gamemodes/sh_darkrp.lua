--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local DARKRP = {}

DARKRP.name = "DarkRP"
DARKRP.gamemodeCallback = function() return DarkRP and true or false end

DARKRP.isPolice = function( player ) return player:getJobTable().category == "Civil Protection" end
DARKRP.addMoney = function( player, amount ) return player:addMoney( amount ) end
DARKRP.getJobName = function( player ) return team.GetName( player:Team() ) end
DARKRP.getJobCategory = function( player ) return player:getJobTable().category end

dHeists.gamemodes:addGamemode( DARKRP )
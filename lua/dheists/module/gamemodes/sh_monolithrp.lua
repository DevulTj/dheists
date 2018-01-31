--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local MONOLITH = {}

MONOLITH.name = "Monolith RP"
MONOLITH.gamemodeCallback = function() return Monolith and true or false end

MONOLITH.isPolice = function( player ) return player:GetJobCategory() == "Police" end
MONOLITH.addMoney = function( player, amount ) return player:AddMoney( amount ) end
MONOLITH.getJobName = function( player ) return team.GetName( player:Team() ) end
MONOLITH.getJobCategory = function( player ) return player:GetJobCategory() end

dHeists.gamemodes:addGamemode( MONOLITH )
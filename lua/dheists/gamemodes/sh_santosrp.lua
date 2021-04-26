--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

local SANTOS = {}

SANTOS.name = "Santos RP"
SANTOS.gamemodeCallback = function() return engine.ActiveGamemode() == "santosrp" end

SANTOS.isPolice = function( player ) return team.GetName( player:Team() ) == "Police" end
SANTOS.addMoney = function( player, amount ) return player:AddMoney( amount ) end
SANTOS.getJobName = function( player ) return team.GetName( player:Team() ) end
SANTOS.getJobCategory = function( player ) return dHeists.gamemodes:getJobList()[ player:Team() ].Name end
SANTOS.notify = function( player, text, notificationType, notificationTime ) return player:AddNote( text ) end

SANTOS.getJobList = function() return GAMEMODE.Jobs:GetJobs() or {} end
SANTOS.getCategoryIndex = function() return "category" end

dHeists.gamemodes:addGamemode( SANTOS )

--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

function dHeists.addMoney( player, amount )
    return dHeists.config.addMoneyFunction and dHeists.config.addMoneyFunction( player, amount ) or player.addMoney and player:addMoney( amount )
end

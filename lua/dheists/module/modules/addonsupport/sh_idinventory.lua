--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

--[[ IDInventory addon support ]]
dHeists.addonSupport:register {
    name = "IDInventory",
    addonCallback = function() return IDInv ~= nil end,

    hooks = {
        {
            hook = "IDInv.CanPickupItem",
            func = function( player, entity )
                if dHeists.pocketWhitelist[ entity:GetClass() ] then return dHeists.pocketWhitelist[ entity:GetClass() ]( entity ) end
            end
        }
    }
}
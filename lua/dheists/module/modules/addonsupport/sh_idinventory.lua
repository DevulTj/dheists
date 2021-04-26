--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

--[[ IDInventory addon support ]]
dHeists.addonSupport:register {
    name = "IDInventory",
    addonCallback = function() return IDInv ~= nil end,

    hooks = {
        {
            hook = "IDInv.CanPickupItem",
            func = function( player, entity )
                if entity.IsDrill then
                    if entity:GetIsDrilling() then return false end

                    return true
                elseif entity.IsBag then
                    if #entity.lootItems > 0 then return false end

                    return true
                elseif entity.IsMask then

                    return true
                end
            end
        }
    }
}

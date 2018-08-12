--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

local function registerAll()
    for sClass, tData in pairs( scripted_ents.GetList() ) do
        if string.find( sClass, "_base" ) then continue end

        local tEntityData = tData.t
        if tEntityData.IsBag or tEntityData.IsDrill or tEntityData.IsMask then
            print("[dHeists-ItemStore] Registered dHeists item: " .. sClass )
            itemstore.config.CustomItems[ sClass ] = { tEntityData.PrintName, "", dHeists.config.itemStoreStackableItem }
        end
    end
end

--[[ itemStore addon support ]]
dHeists.addonSupport:register {
    name = "itemStore",
    addonCallback = function() return itemstore ~= nil end,

    callback = function()
        if dHeists.config.itemStoreDisabled == true then return end

        registerAll()
        itemstore.items.Load()
    end
}
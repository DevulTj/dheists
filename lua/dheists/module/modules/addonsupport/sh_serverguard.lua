--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }}
]]

--[[ Serverguard permission support ]]
dHeists.addonSupport:register {
    name = "ServerGuard",
    addonCallback = function() return serverguard ~= nil end,

    callback = function()
        for _, name in pairs( dHeists.privileges ) do
            serverguard.permission:Add( name )
        end
    end,
}
--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

dHeists.addonSupport = dHeists.addonSupport or {}
dHeists.addonSupport.addons = dHeists.addonSupport.addons or {}

function dHeists.addonSupport:register( data )
    self.addons[ data.name ] = data
end

hook.Add( "InitPostEntity", "dHeists.addonSupport", function()
    dHeists.print( "Looping addons for addon support." )
    for name, data in pairs( dHeists.addonSupport.addons ) do
        local hooks = data.hooks

        local isRunningAddon = data.addonCallback()
        if not isRunningAddon then continue end

        dHeists.print( Format( "Found addon '%s', including all hooks.", name ) )

        -- Support for addon found callback
        if data.callback then data.callback() end

        for id, hookData in pairs( hooks or {} ) do
            hook.Add( hookData.hook, "dHeists_" .. hookData.hook .. "_" .. id, hookData.func )
        end
    end
end )

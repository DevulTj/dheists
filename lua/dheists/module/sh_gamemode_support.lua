--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

dHeists.gamemodes = dHeists.gamemodes or {}
dHeists.gamemodes.list = {}

-- dHeists.gamemodes.currentGamemode = nil

function dHeists.gamemodes:addGamemode( data )
    if not data or not data.name then return end

    self.list[ data.name ] = data

    dHeists.print( "Registered gamemode " .. data.name )
end

frile.includeFolder( "dheists/gamemodes/" )

function dHeists.gamemodes:findCurrentGamemode()
    for name, data in pairs( self.list ) do

        if data.gamemodeCallback and data.gamemodeCallback() then
            self.currentGamemode = name
            hook.Run( "dHeists.onGamemodeLoaded" )

            break
        end
    end
end

dHeists.gamemodes.list.default = {
    addMoney = function() end,
    isPolice = function() return false end,
    getJobName = function() return "N/A" end,
    getJobCategory = function() return "N/A" end,
    notify = function( player, text, notificationType ) return player:SendLua([[notification.AddLegacy(]] .. ( text or "No messsage!" ) .. [[, ]] .. ( notificationType or 0 ) .. [[ )]]) end,
    getJobList = function() end,
    getCategoryIndex = function() end,
}

function dHeists.gamemodes:getGamemode()
    return self.list[ self.currentGamemode ] or self.list.default
end

function dHeists.gamemodes:addMoney( player, amount )
    return self:getGamemode().addMoney( player, amount )
end

function dHeists.gamemodes:isPolice( player )
    return self:getGamemode().isPolice( player )
end

function dHeists.gamemodes:getJobName( player )
    return self:getGamemode().getJobName( player )
end

function dHeists.gamemodes:getJobCategory( player )
    return self:getGamemode().getJobCategory( player )
end

function dHeists.gamemodes:notify( player, text, notificationType )
    return self:getGamemode().notify( player, text, notificationType )
end

function dHeists.gamemodes:getJobList()
    return self:getGamemode().getJobList()
end

function dHeists.gamemodes:getCategoryIndex()
    return self:getGamemode().getCategoryIndex()
end

-- Run this automagically

hook.Add( "InitPostEntity", "dHeists.gamemodes", function()
    dHeists.gamemodes:findCurrentGamemode()

    hook.Run( "dHeists.InitPostEntity" )
end )

-- Lua refresh support
dHeists.gamemodes:findCurrentGamemode()
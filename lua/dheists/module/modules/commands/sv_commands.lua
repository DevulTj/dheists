--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.commands = {}
dHeists.commands.list = {}

dHeists.commands.defaultCommandPrefix = "/"

function dHeists.commands:add( tData )
    local sPrefix = tData.prefix or dHeists.commands.defaultCommandPrefix
    local sName = tData.name

    tData = {
        command = sName,
        prefix = sPrefix,
        canDo = tData.canDo,
        func = tData.func
    }

    dHeists.commands.list[ sPrefix ] = dHeists.commands.list[ sPrefix ] or {}
    dHeists.commands.list[ sPrefix ][ sName ] = tData
end

if SERVER then
    hook.Add( "PlayerSay", "dHeists.commands.runCommands", function( pPlayer, sText )
        local sPrefix = sText:sub( 1, 1 ) -- Store prefix
        sText = sText:sub( 2 ) -- Ditch it in the whole text

        sText = string.Explode( " ", sText )
        if #sText < 1 then return end -- Empty command

        if dHeists.commands.list[ sPrefix ] then
            local sCommand = sText[ 1 ]
            local tData = dHeists.commands.list[ sPrefix ][ sCommand ] -- Check if the command exists

            table.remove( sText, 1 ) -- Remove the command from the args list

            if tData then
                local canDo, reason = tData.canDo and tData.canDo( pPlayer, tData )
                if canDo == false then
                    if reason then
                        dHeists.addNotification( pPlayer, reason )
                    end

                    return ""
                end

                tData.func( pPlayer, sText, tData ) -- Execute the command
                hook.Run( "dHeists.commands.onCommand", pPlayer, sText, tData ) -- Hook support

                return ""
            end
        end
    end )
end

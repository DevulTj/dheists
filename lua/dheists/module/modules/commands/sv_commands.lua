--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.commands = {}
dHeists.commands.list = {}

dHeists.commands.defaultCommandPrefix = "/"

function dHeists.commands:add( commandData )
    local prefix = commandData.prefix or dHeists.commands.defaultCommandPrefix
    local name = commandData.name

    commandData = {
        command = name,
        prefix = prefix,
        canDo = commandData.canDo,
        func = commandData.func
    }

    dHeists.commands.list[ prefix ] = dHeists.commands.list[ prefix ] or {}
    dHeists.commands.list[ prefix ][ name ] = commandData
end

if SERVER then
    hook.Add( "PlayerSay", "dHeists.commands.runCommands", function( player, text )
        local prefix = text:sub( 1, 1 ) -- Store prefix
        text = text:sub( 2 ) -- Ditch it in the whole text

        text = string.Explode( " ", text )
        if #text < 1 then return end -- Empty command

        if dHeists.commands.list[ prefix ] then
            local command = text[ 1 ]
            local commandData = dHeists.commands.list[ prefix ][ command ] -- Check if the command exists

            table.remove( text, 1 ) -- Remove the command from the args list

            if commandData then
                local canDo, reason = commandData.canDo and commandData.canDo( player, commandData )
                if canDo == false then
                    if reason then
                        dHeists.addNotification( player, reason )
                    end

                    return ""
                end

                commandData.func( player, text, commandData ) -- Execute the command
                hook.Run( "dHeists.commands.onCommand", player, text, commandData ) -- Hook support

                return ""
            end
        end
    end )
end

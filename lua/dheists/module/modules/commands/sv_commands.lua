--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

dHeists.commands = {}
dHeists.commands.list = {}
dHeists.commands.prefixes = {}

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

    dHeists.commands.list[ name ] = commandData
    dHeists.commands.prefixes[ prefix ] = true
end

if SERVER then
    function dHeists.commands:run( player, text, commandData )
        if commandData then
            local canDo, reason = commandData.canDo and commandData.canDo( player, commandData )
            if canDo == false then
                if reason then
                    player:dHeistsNotify( reason, NOTIFY_ERROR )
                end

                return ""
            end

            commandData.func( player, text, commandData ) -- Execute the command
            hook.Run( "dHeists.commands.onCommand", player, text, commandData ) -- Hook support

            return ""
        end
    end

    hook.Add( "PlayerSay", "dHeists.commands.runCommands", function( player, text )
        local prefix = text:sub( 1, 1 ) -- Store prefix
        text = text:sub( 2 ) -- Ditch it in the whole text

        text = string.Explode( " ", text )
        if #text < 1 then return end -- Empty command

        if dHeists.commands.prefixes[ prefix ] then
            local command = text[ 1 ]
            local commandData = dHeists.commands.list[ command ] -- Check if the command exists
            if not commandData then return end

            -- Make sure the prefix is valid
            if prefix ~= commandData.prefix then return end

            table.remove( text, 1 ) -- Remove the command from the args list

            dHeists.commands:run( player, text, commandData )

            return ""
        end
    end )

    concommand.Add( "dHeists", function( player, cmd, args )
        local command = args[ 1 ]
        local commandData = dHeists.commands.list[ command ]
        if not commandData then return end

        dHeists.commands:run( player, table.concat( args, " ", 2 ), commandData )
    end )
end

dHeists.commands:add( {
    name = "dheists",
    canDo = function( player, commandData )
        return true
    end,
    func = function( player, text, commandData )
        player:SendLua([[
            chat.AddText( Color( 255, 50, 50 ), "[dHeists]", color_white, " This addon was created by DevulTj & fruitwasp." )
        ]])
    end
} )

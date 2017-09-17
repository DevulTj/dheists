
local version = 1

if commander and commander.VERSION >= version then return end

commander = {
    VERSION = version,
    AUTHOR = "fruitwasp, DevulTj",
    AUTHOR_URL = "https://steamcommunity.com/id/fruitwasp",

    IDENTIFIER = "commander",
    DEFAULT_NOTIFICATION_LENGTH_TIME = 4,
    DEFAULT_COMMAND_PREFIX = "/"
}

commander.List = {}
commander.Prefixes = {}

function commander:register( commandData )
    local prefix = commandData.prefix or commander.DEFAULT_COMMAND_PREFIX
    local command = commandData.command

    commandData = {
        command = command,
        prefix = prefix,
        canDo = commandData.canDo,
        func = commandData.func,
        global = commandData.global or commander.IDENTIFIER
    }

    if not commander.List[ commandData.global ] then
        concommand.Add( commandData.global, function( player, global, arguments )
            local command = args[ 1 ]
            if not commander.List[ global ][ command ] then return end

            commander:run( player, table.concat( arguments, " ", 2 ), commandData )
        end )
    end

    commander.List[ commandData.global ] = commander.List[ commandData.global ] or {}
    commander.List[ commandData.global ][ command ] = commandData

    commander.Prefixes[ prefix ] = true
end

function commander:run( player, text, commandData )
    if not commandData then return end

    local canRun, message = hook.Call( "commander.canCommand", nil, player, text, commandData )

    if canRun == false then
        frotify.notify( message or "Command could not be executed", NOTIFY_ERROR, commander.DEFAULT_NOTIFICATION_LENGTH_TIME, player )

        return
    end

    canRun, message = commandData.canDo and commandData.canDo( player, commandData )

    if canRun == false then
        frotify.notify( message or "Command could not be executed", NOTIFY_ERROR, commander.DEFAULT_NOTIFICATION_LENGTH_TIME, player )

        return
    end

    commandData.func( player, text, commandData ) -- Execute the command
    hook.Run( "commander.onCommand", player, text, commandData ) -- Hook support
end

hook.Add( "PlayerSay", commander.IDENTIFIER, function( player, text )
    local prefix = string.sub( text, 1, 1 )-- Store prefix
    text = string.sub( text, 2 ) -- Ditch it in the whole text

    text = string.Explode( " ", text )
    if #text < 1 then return end -- Empty command

    if commander.Prefixes[ prefix ] then
        text = string.Explode( "_", text )

        local global = text[ 1 ]
        local command = text[ 2 ]
        local commandData = commander.List[ global ]
            and commander.List[ global ][ command ]

        if not commandData then return end -- Check if the command exists

        -- Make sure the prefix is valid
        if prefix ~= commandData.prefix then return end

        table.remove( text, 1 ) -- Remove the command from the args list

        commander:run( player, text, commandData )

        return ""
    end
end )

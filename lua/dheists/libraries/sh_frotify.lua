
local version = 3

if frotify and frotify.VERSION >= version then return end

frotify = {
    VERSION = version,
    AUTHOR = "fruitwasp",
    AUTHOR_URL = "https://steamcommunity.com/id/fruitwasp",

    DEFAULT_PREFIX = "[game]",
    PRINT_PREFIX_COLOR = Color( 0, 255, 0 ),
    PRINT_COLOR = Color( 255, 255, 255 ),

    DEFAULT_NOTIFICATION_LENGTH_TIME = 4
}

function frotify.print( message, prefix )
    prefix = prefix or frotify.DEFAULT_PREFIX

    MsgC( frotify.PRINT_PREFIX_COLOR, prefix .. " ", frotify.PRINT_COLOR, message .. "\n" )
end

if SERVER then
    NOTIFY_GENERIC = NOTIFY_GENERIC or 0
    NOTIFY_ERROR = NOTIFY_ERROR or 1
    NOTIFY_UNDO = NOTIFY_UNDO or 2
    NOTIFY_HINT = NOTIFY_HINT or 3
    NOTIFY_CLEANUP = NOTIFY_CLEANUP or 4

    util.AddNetworkString( "frotify" )

    function frotify.notify( message, messageType, timeLength, targets )
        messageType = messageType or NOTIFY_GENERIC
        timeLength = timeLength or frotify.DEFAULT_NOTIFICATION_LENGTH_TIME

        net.Start( "frotify" )
            net.WriteString( message )
            net.WriteUInt( messageType, 2 )
            net.WriteUInt( timeLength, 4 )
        net.Send( targets or player.GetAll() )
    end

    if DarkRP then
        function DarkRP.notify( targets, messageType, timeLength, message )
            frotify.notify( message, messageType, timeLength, targets )
        end
    end
end

if CLIENT then
    net.Receive( "frotify", function()
        local message = net.ReadString()
        local messageType = net.ReadUInt( 2 )
        local timeLength = net.ReadUInt( 4 )

        frotify.notify( message, messageType, timeLength )
    end )

    function frotify.notify( message, messageType, timeLength )
        notification.AddLegacy( message, messageType, timeLength )
    end
end

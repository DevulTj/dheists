
local version = 1

if fracker and fracker.VERSION >= version then return end

fracker = {
    VERSION = version,
    AUTHOR = "fruitwasp",
    AUTHOR_URL = "https://steamcommunity.com/id/fruitwasp",

    PRINT_PREFIX = "[fracker]",

    TRACK_URL = "https://fracker-api.herokuapp.com/api/track",
    TRACK_INTERVAL = 60 * 60,
    TRACK_REPETITIONS = 1,
}

local trackers = {}

function fracker.registerTracker( trackerInfo )
    table.insert( trackers, trackerInfo )
end

function fracker.track( variables )
    http.Post( fracker.TRACK_URL, {
        script_id = variables.id,
        script_version_id = variables.versionId,
        user_id = variables.userId
    } )
end

hook.Add( "InitPostEntity", "fracker", function()
    timer.Create( "fracker", fracker.TRACK_INTERVAL, fracker.TRACK_REPETITIONS, function()
        for _, trackerInfo in ipairs( trackers ) do
            fracker.track( trackerInfo )
        end
    end )
end )
--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ADDON_PREFIX = "[Content-Manager]"
local function printDebug( sText )
    dHeists.print( "${prefix} ${text}" % {
        prefix = ADDON_PREFIX,
        text = sText,
    } )
end

local ADDON_ADD_RESOURCE = "Added addon resources for ID '${id}'."
local function printAddResource( sID )
    printDebug( ADDON_ADD_RESOURCE % {
        id = sID
    } )
end

local ADDON_MISSING = "Missing content detected! Couldn't find addon with ID '${id}'."
local function printMissingContent( sID )
    printDebug( ADDON_MISSING % {
        id = sID
    } )
end

local ADDONS = {
    "941544793",
    "726820415",
    "357350543",
    "970777104"
}

local function addWorkshopResources()
    for _, sID in pairs( ADDONS ) do
        resource.AddWorkshop( sID )

        printAddResource( sID )
    end
end
if not game.SinglePlayer() and SERVER then
    addWorkshopResources()
end

local ADDON_ALL_FOUND = "All addons were found!"
hook.Add( "InitPostEntity", "dHeits.Module.ContentChecker", function()
    local tAddonCopy = table.Copy( ADDONS )
    for _, tData in pairs( engine.GetAddons() ) do
        table.RemoveByValue( tAddonCopy, tData.wsid )
    end

    if table.Count( tAddonCopy ) == 0 then
        printDebug( ADDON_ALL_FOUND )
    else
        for _, sID in pairs( tAddonCopy ) do
            printMissingContent( sID )
        end
    end
end )

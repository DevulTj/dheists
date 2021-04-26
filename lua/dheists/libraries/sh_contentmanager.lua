--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

local ADDON_CONTENT             = "[dHeists] "
local ADDON_PREFIX              = "[CONTENT-MANAGER] " .. ADDON_CONTENT
local ADDON_PREFIX_SUCCESS      = ADDON_PREFIX .. "[SUCCESS] "
local ADDON_PREFIX_WARN         = ADDON_PREFIX .. "[WARN] "
local ADDON_PREFIX_ERROR        = ADDON_PREFIX .. "[ERROR] "

local ADDON_GENERATOR_START     = "local ADDON_TABLE = {\n"
local ADDON_GENERATOR_END       = "}"

local ADDON_DEBUG_ADD_RESOURCE  = "Added addon resource for ID '${id}' (${title})."
local ADDON_DEBUG_MISSING_CHAT  = "Missing content detected, please subscribe to all required content, check the console for details."
local ADDON_DEBUG_MISSING_START = "Missing content detected! Couldn't find the following addons."
local ADDON_DEBUG_MISSING_TEXT  = "Missing addon '${id}' (${title}), download at http://steamcommunity.com/sharedfiles/filedetails/?id=${id}"
local ADDON_DEBUG_FOUND_ALL     = "All addons were found!"
local ADDON_DEBUG_ADDED_ALL     = "All addon resources where added to the server!"
local ADDON_DEBUG_SAVED_ALL     = "Saved generated addon table in 'fcm_addons.txt'!"
local ADDON_NO_STRING_INTERPOL  = "Unable to find string interpolation, adding one."

local ADDON_COLOR_GREEN         = 1
local ADDON_COLOR_RED           = 2
local ADDON_COLOR_WHITE         = 3
local ADDON_COLOR_TABLE = {
    [ ADDON_COLOR_GREEN ]       = Color( 0, 255, 0 ),
    [ ADDON_COLOR_RED ]         = Color( 255, 0, 0 ),
    [ ADDON_COLOR_WHITE ]       = Color( 255, 255, 255 )
}

local ADDON_TABLE = {
    [ "726820415" ] = "PAYDAY Bank Robbery System Content",
    [ "357350543" ] = "Jesse V92's Released Models",
    [ "970777104" ] = "dHeists: Content Pack",
    [ "941544793" ] = "gta5_office_accessories",
}

local function printSuccess( sText )
    local cGreen = ADDON_COLOR_TABLE[ ADDON_COLOR_GREEN ]
    local cWhite = ADDON_COLOR_TABLE[ ADDON_COLOR_WHITE ]

    MsgC( cGreen, ADDON_PREFIX_SUCCESS, cWhite, sText, "\n" )
end

local function printWarn( sText )
    local cRed = ADDON_COLOR_TABLE[ ADDON_COLOR_RED ]
    local cWhite = ADDON_COLOR_TABLE[ ADDON_COLOR_WHITE ]

    MsgC( cRed, ADDON_PREFIX_WARN, cWhite, sText, "\n" )
end

local function printChat( sText )
    local cRed = ADDON_COLOR_TABLE[ ADDON_COLOR_RED ]
    local cWhite = ADDON_COLOR_TABLE[ ADDON_COLOR_WHITE ]

    chat.AddText( cRed, ADDON_PREFIX, cWhite, sText )
end

if not getmetatable( "" ).__mod then
    printWarn( ADDON_NO_STRING_INTERPOL )

    getmetatable( "" ).__mod = function( sStr, tTab )
        return sStr:gsub( "($%b{})", function( sW )
                return tTab[ sW:sub( 3, -2 ) ] or sW
        end )
    end
end

local function downloadSteamworksAddon( id )
    steamworks.FileInfo( id, function( dat )
        if not dat then return end

        notification.AddProgress( "Steamworks_" .. id, "Downloading " .. dat.title .. " via workshop..." )

        steamworks.Download( dat.fileid, true, function( path )
            game.MountGMA( path )
            notification.Kill( "Steamworks_" .. id )
        end )
    end )
end

local function checkForMissingAddons()
    local tAddonCopy = table.Copy( ADDON_TABLE )
    for _, tData in pairs( engine.GetAddons() ) do
        tAddonCopy[ tData.wsid ] = nil
    end

    if table.Count( tAddonCopy ) == 0 then
        if CLIENT then
            printChat( ADDON_DEBUG_FOUND_ALL )
        end

        printSuccess( ADDON_DEBUG_FOUND_ALL )
    else
        if CLIENT then
            printChat( ADDON_DEBUG_MISSING_CHAT )
        end

        printWarn( ADDON_DEBUG_MISSING_START )
        for sID, sTitle in pairs( tAddonCopy ) do
            printWarn( ADDON_DEBUG_MISSING_TEXT % {
                id = sID,
                title = sTitle
            } )

            if CLIENT then
                downloadSteamworksAddon( sID )
            end
        end
    end
end

if SERVER then
    local function addWorkshopResources()
        for sID, sTitle in pairs( ADDON_TABLE ) do
            printSuccess( ADDON_DEBUG_ADD_RESOURCE % {
                id = sID,
                title = sTitle
            } )

            resource.AddWorkshop( sID )
        end
    end

    if not game.SinglePlayer() then
        addWorkshopResources()
    end

    hook.Add( "InitPostEntity", "FCM.ContentChecker", function()
        checkForMissingAddons()
    end )

    concommand.Add( "fcm_generate_addon_table", function( pPlayer, sCMD, tArgs, sArgs )
        if pPlayer ~= NULL or pPlayer:IsPlayer() then return end

        local sStr = ADDON_GENERATOR_START
        for _, tData in pairs( engine.GetAddons() ) do
            sStr = "${str}    [ \"${id}\" ] = \"${title}\",\n" % {
                str = sStr,
                id = tData.wsid,
                title = tData.title
            }
        end

        file.Write( "fcm_addons.txt", sStr .. ADDON_GENERATOR_END )
        printSuccess( ADDON_DEBUG_SAVED_ALL )
    end )
else
    FCM = FCM or {}
    FCM.FullySpawned = FCM.FullySpawned or false

    hook.Add( "PlayerFootstep", "FCM.PlayerFootstep", function( pPlayer, vPos, iFoot, sSound, iVolume, tRF )
        if pPlayer ~= LocalPlayer() then return end

        if not FCM.FullySpawned then
            FCM.FullySpawned = true

            checkForMissingAddons()

            hook.Remove( "PlayerFootstep", "FCM.PlayerFootstep" )
        end
    end )
end

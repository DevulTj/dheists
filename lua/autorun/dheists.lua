--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists = dHeists or {
    VERSION = 1,

    IDENTIFIER = "dheists",

    config = {},
    npc = {}
}

function dHeists.print( ... )
    return MsgC( Color( 255, 0, 0 ), "[dHeists] ", color_white, ..., "\n" )
end

--[[
    File Loading
]]
local version = 1

if not frile or frile.VERSION < version then
    frile = {
        VERSION = version,

        STATE_SERVER = 0,
        STATE_CLIENT = 1,
        STATE_SHARED = 2
    }

    function frile.includeFile( filename, state )
        if state == frile.STATE_SHARED or filename:find( "sh_" ) then
            if SERVER then AddCSLuaFile( filename ) end
            include( filename )
        elseif state == frile.STATE_SERVER or SERVER and filename:find( "sv_" ) then
            include( filename )
        elseif state == frile.STATE_CLIENT or filename:find( "cl_" ) then
            if SERVER then AddCSLuaFile( filename )
            else include( filename ) end
        end
    end

    function frile.includeFolder( currentFolder, ignoreFilesInFolder, ignoreFoldersInFolder )
        if file.Exists( currentFolder .. "sh_frile.lua", "LUA" ) then
            frile.includeFile( currentFolder .. "sh_frile.lua" )

            return
        end

        local files, folders = file.Find( currentFolder .. "*", "LUA" )

        if not ignoreFilesInFolder then
            for _, File in ipairs( files ) do
                frile.includeFile( currentFolder .. File )
            end
        end

        if not ignoreFoldersInFolder then
            for _, folder in ipairs( folders ) do
                frile.includeFolder( currentFolder .. folder .. "/" )
            end
        end
    end
end

 -- Load everything
frile.includeFolder( "dheists/libraries/" )
frile.includeFolder( "dheists/config/", nil, true )
frile.includeFolder( "dheists/config/languages/" )
frile.includeFolder( "dheists/entities/" )
frile.includeFolder( "dheists/module/" )

if SERVER then
    dHeistsDB.initialize( dHeists.dbConfig )
end
--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists = dHeists or {}

function dHeists.print( ... )
    return MsgC( Color( 255, 0, 0 ), "[dHeists] ", color_white, ..., "\n" )
end

function dHeists.include( fileName, state )
    if not fileName then return end

    if ( state == "server" or fileName:find("sv_" ) ) and SERVER then
        include( fileName )
    elseif state == "shared" or fileName:find( "sh_" ) then
        if SERVER then
            AddCSLuaFile( fileName )
        end

        include( fileName )
    elseif state == "client" or fileName:find( "cl_" ) then
        if SERVER then
            AddCSLuaFile( fileName )
        else
            include( fileName )
        end
    end

    dHeists.print( "Included file " .. fileName )
end

function dHeists.includeFolder( currentFolder, noCheckInnerFolders )
    local files, folders = file.Find( currentFolder .. "*", "LUA" )

    for _, File in pairs( files ) do
        dHeists.include( currentFolder .. File )
    end

    if noCheckInnerFolders then return end
    for _, folder in pairs( folders ) do
        dHeists.includeFolder( currentFolder .. folder .. "/" )
    end
end

--[[
    File Loading
]]

dHeists.config = dHeists.config or {} -- Initialize configuration table
dHeists.includeFolder( "dheists/config/" ) -- Load all configurations

dHeists.includeFolder( "dheists/libraries/" )

dHeists.include( "dheists/sv_content.lua" )
dHeists.include( "dheists/sv_actions.lua" )
dHeists.include( "dheists/cl_actions.lua" )
dHeists.include( "dheists/sh_load_entities.lua" )
--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists = dHeists or {}

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

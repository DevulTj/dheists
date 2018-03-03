--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.drills = dHeists.drills or {}
dHeists.drills.list = {}

function dHeists.drills:registerDrill( drillName, data )
    if not drillName then return end

    data.name = drillName
    self.list[ drillName ] = data

    hook.Run( "dHeists.drills.register", drillName, data )

    return data
end

function dHeists.drills:getDrill( drillName )
    return self.list[ drillName ]
end

-- Include configuration for bags
frile.includeFile( "dheists/config/config_entities/sh_drills.lua" )
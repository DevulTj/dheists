--[[
    © 2021 Tony Ferguson, do not share, re-distribute or modify

    without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

dHeists.robbing = dHeists.robbing or {}
dHeists.robbing.list = {}

function dHeists.robbing:registerEnt( entName, data )
    if not entName then return end

    data.name = entName
    dHeists.robbing.list[ entName ] = data
end

function dHeists.robbing.getEnt( entName )
    return dHeists.robbing.list[ entName ]
end

function dHeists.robbing:getEntNames()
    local tbl = {}
    for name, data in pairs( self.list ) do
        table.insert( tbl, name )
    end

    return tbl
end

hook.Run( "dHeists.robbing.registerEnt" )

-- Include configuration for robbing
frile.includeFile( "dheists/config/config_entities/sh_robbing.lua" )

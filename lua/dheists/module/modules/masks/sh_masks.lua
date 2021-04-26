--[[
    © 2021 Tony Ferguson, do not share, re-distribute or modify

    without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

dHeists.masks = dHeists.masks or {}
dHeists.masks.list = {}

function dHeists.masks:registerMask( maskName, data )

end

function dHeists.masks.getMask( maskName )
    return dHeists.masks.list[ maskName ]
end

hook.Run( "dHeists.masks.registerMasks" )

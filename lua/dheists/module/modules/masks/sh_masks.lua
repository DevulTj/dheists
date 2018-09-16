--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

dHeists.masks = dHeists.masks or {}
dHeists.masks.list = {}

function dHeists.masks:registerMask( maskName, data )

end

function dHeists.masks.getMask( maskName )
    return dHeists.masks.list[ maskName ]
end

hook.Run( "dHeists.masks.registerMasks" )

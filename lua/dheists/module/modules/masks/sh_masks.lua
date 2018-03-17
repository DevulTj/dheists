--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com) - {{ user_id }}
]]

dHeists.masks = dHeists.masks or {}
dHeists.masks.list = {}

function dHeists.masks:registerMask( maskName, data )
    if not maskName then return end

    local objectName = "mask_" .. maskName

    renderObjects:registerObject( objectName, {
        model = data.model,
        bone = "ValveBiped.Bip01_Head1",
        pos = data.pos,
        ang = data.ang,

        skin = data.skin,
        scale = data.scale
    } )


    data.name = maskName
    dHeists.masks.list[ maskName ] = data

    hook.Run( "dHeists.masks.registerMask", maskName, data, objectName )
end

function dHeists.masks.getMask( maskName )
    return dHeists.masks.list[ maskName ]
end

hook.Run( "dHeists.masks.registerMasks" )

-- Include configuration for masks
frile.includeFile( "dheists/config/config_entities/sh_masks.lua" )
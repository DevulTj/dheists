--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

dHeists.masks = dHeists.masks or {}
dHeists.masks.list = {}

function dHeists.masks:registerMask( maskName, data )
    if not maskName then return end

    renderObjects:registerObject( "mask_" .. maskName, {
        model = data.model,
        bone = "ValveBiped.Bip01_Head1",
        pos = data.pos,
        ang = data.ang,

        skin = data.skin,
        scale = data.scale
    } )


    data.name = maskName
    dHeists.masks.list[ maskName ] = data
end

function dHeists.masks.getMask( maskName )
    return dHeists.masks.list[ maskName ]
end

hook.Run( "dHeists.masks.registerMasks" )

-- Include configuration for masks
frile.includeFile( "dheists/config/config_entities/sh_masks.lua" )
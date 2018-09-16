--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

hook.Add( "InitPostEntity", dHeists.IDENTIFIER .. "cache", function()
    dHeists.CURRENT_LEVEL = game.GetMap()
end )


hook.Add( "OnReloaded", dHeists.IDENTIFIER .. "reload", function()
    hook.Run( "dHeists.zones.registerZones" )
    hook.Run( "dHeists.robbing.registerEnt" )
    hook.Run( "dHeists.loot.registerLoot" )
    hook.Run( "dHeists.ent.registerEnts" )
end )

hook.Add( "PostGamemodeLoaded", dHeists.IDENTIFIER .. "register", function()
    for sClass, tData in pairs( scripted_ents.GetList() ) do
        if string.find( sClass, "_base" ) then continue end

        local tEntityData = tData.t
        if tEntityData.IsBag then
            renderObjects:registerObject( sClass, {
                model = tEntityData.BagModel,
                bone = tEntityData.BagBone or "ValveBiped.Bip01_Spine",
                pos = tEntityData.BagPos,
                ang = tEntityData.BagAng,

                skin = tEntityData.BagSkin,
                scale = tEntityData.BagScale
            } )
        elseif tEntityData.IsMask then
            renderObjects:registerObject( sClass, {
                model = tEntityData.MaskModel,
                bone = tEntityData.MaskBone or "ValveBiped.Bip01_Head1",
                pos = tEntityData.MaskPos,
                ang = tEntityData.MaskAng,

                skin = tEntityData.MaskSkin,
                scale = tEntityData.MaskScale
            } )
        end
    end
end )
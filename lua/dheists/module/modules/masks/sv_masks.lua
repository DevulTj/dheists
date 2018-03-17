--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com) - {{ user_id }}
]]

hook.Add( "PlayerButtonDown", dHeists.IDENTIFIER .. "_masks", function( ply, button )
    if button == dHeists.config.maskEquipKey then
        if ply:getMask() then
            ply:toggleMask()
        end
    end
end )
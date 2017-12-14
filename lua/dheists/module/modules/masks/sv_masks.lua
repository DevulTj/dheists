--[[
    © 2017 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

hook.Add( "PlayerButtonDown", dHeists.IDENTIFIER .. "_masks", function( ply, button )
    if button == KEY_H then
        if ply:getMask() then
            ply:toggleMask()
        end
    end
end )
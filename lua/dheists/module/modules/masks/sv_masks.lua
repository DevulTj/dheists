--[[
    © 2021 Tony Ferguson, do not share, re-distribute or modify

    without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

hook.Add( "PlayerButtonDown", dHeists.IDENTIFIER .. "_masks", function( ply, button )
    if button == dHeists.config.maskEquipKey then
        ply:toggleMask()
    end
end )

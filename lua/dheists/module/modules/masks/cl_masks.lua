--[[
    © 2017 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

local hudX, hudY = ScrW() - 4, ScrH() * 0.57


hook.Add( "HUDPaint", dHeists.IDENTIFIER .. "_mask", function()
    if #LocalPlayer():getDevString( "currentMask", nil ) ~= 0 then
        local throwText = ("[%s] TO %s MASK"):format( input.GetKeyName( dHeists.config.maskEquipKey ):upper(), LocalPlayer():getDevBool( "maskEquipped", false ) and "UN-EQUIP" or "EQUIP" )

        draw.SimpleText( throwText, "dHeists_bagText", hudX + 2, hudY - 26, Color( 0, 0, 0, 185 ), TEXT_ALIGN_RIGHT )
        draw.SimpleText( throwText, "dHeists_bagText", hudX, hudY - 28, Color( 240, 240, 240, 255 ), TEXT_ALIGN_RIGHT )
    end
end )
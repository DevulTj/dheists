--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

local hudX, hudY = ScrW() - 4, ScrH() * 0.57


hook.Add( "HUDPaint", dHeists.IDENTIFIER .. "_mask", function()
    if #LocalPlayer():getDevString( "currentMask", nil ) ~= 0 then
        local isEquipped = LocalPlayer():getDevBool( "maskEquipped", false )
        local keyName = input.GetKeyName( dHeists.config.maskEquipKey ):upper()
        local throwText = ("[%s] %s MASK"):format( keyName, isEquipped and "UN-EQUIP" or "EQUIP" )

        if not isEquipped then
            local dropText = ("[SHIFT+%s] DROP"):format( keyName )
            draw.SimpleText( dropText, "dHeists_bagTextItalics", hudX + 2, hudY - 26 - 18, Color( 0, 0, 0, 185 ), TEXT_ALIGN_RIGHT )
            draw.SimpleText( dropText, "dHeists_bagTextItalics", hudX, hudY - 26 - 20, Color( 170, 255, 170, 255 ), TEXT_ALIGN_RIGHT )
        end

        draw.SimpleText( throwText, "dHeists_bagText", hudX + 2, hudY - 26, Color( 0, 0, 0, 185 ), TEXT_ALIGN_RIGHT )
        draw.SimpleText( throwText, "dHeists_bagText", hudX, hudY - 28, Color( 240, 240, 240, 255 ), TEXT_ALIGN_RIGHT )
    end
end )
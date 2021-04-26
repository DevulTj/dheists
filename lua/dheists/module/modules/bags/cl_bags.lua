--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

hook.Add( "PlayerButtonDown", "dHeists.dropBag", function( player, buttonId )
    if not IsFirstTimePredicted() then return end
    if player ~= LocalPlayer() then return end
    if buttonId ~= dHeists.config.dropBagKey then return end

    RunConsoleCommand( "dheists_dropbag" )
end )

local roll = 0
hook.Add( "CalcView", "dHeists.drawBag", function( player, origin, angles, fov )
    if dHeists.config.disableBagTilt then return end

    if roll ~= 0 or ( roll == 0 and player:dHeists_isCarryingBag() ) then
        roll = Lerp( FrameTime() * 10, roll, player:dHeists_isCarryingBag() and dHeists.config.holdingBagAngleOffset or 0 )

        local view = {}
        view.angles = Angle( angles.p, angles.y, angles.r + roll )

        return view
    end
end )

local hudX, hudY = ScrW() - 4, ScrH() * 0.6
local width, height = 230, 40

dHeists.addedHeight = dHeists.addedHeight or 0
hook.Add( "HUDPaint", "dHeists.drawBag", function()
    if LocalPlayer():dHeists_isCarryingBag() then
        local throwText =  "[" .. input.GetKeyName( dHeists.config.dropBagKey ):upper() .. "] " .. dL( "throw_item" )
        local itemsText = LocalPlayer()._dHeistsLootItems or dL( "no_items" )

        surface.SetFont( "dHeists_bagText" )
        local textW, textH = surface.GetTextSize( itemsText )
        local carryingText = dL( "carrying_text" )
        local carryingTextW, carryingTextH = surface.GetTextSize( carryingText )

        if textW < carryingTextW then textW = carryingTextW end

        textW = textW + 16

        surface.DrawCuteRect( hudX - textW, hudY, textW, height + ( dHeists.addedHeight > 0 and dHeists.addedHeight or 28 ), 3, 100 )

        draw.SimpleText( throwText, "dHeists_bagText", hudX + 2, hudY - 26, Color( 0, 0, 0, 185 ), TEXT_ALIGN_RIGHT )
        draw.SimpleText( throwText, "dHeists_bagText", hudX, hudY - 28, Color( 240, 240, 240, 255 ), TEXT_ALIGN_RIGHT )

        draw.SimpleText( carryingText, "dHeists_bagText", hudX + 12 - textW, hudY + 8, Color( 0, 0, 0, 185 ) )
        draw.SimpleText( carryingText, "dHeists_bagText", hudX + 10 - textW, hudY + 6, color_white )

        draw.DrawText( itemsText, "dHeists_bagText", hudX + 12 - textW, hudY + 36, Color( 0, 0, 0, 185 ) )
        draw.DrawText( itemsText, "dHeists_bagText", hudX + 10 - textW, hudY + 34, color_white )
    end
end )

net.Receive( "dHeists.sendBagItems", function()
    dHeists.addedHeight = 0
    local lootItems = net.ReadTable()

    LocalPlayer()._dHeistsBag = {
        lootItems = lootItems
    }

    if #lootItems == 0 then
        LocalPlayer()._dHeistsLootItems = nil

        return
    end

    local lootStuff = {}
    for _, itemName in pairs( lootItems ) do
        dHeists.addedHeight = dHeists.addedHeight + ( not lootStuff[ itemName ] and 28 or 0 )

        lootStuff[ itemName ] = ( lootStuff[ itemName ] or 0 ) + 1
    end

    local lootString = ""
    for itemName, amount in pairs( lootStuff ) do
        itemName = dL( itemName )

        lootString = lootString .. "" .. ( amount > 1 and ( ( amount .. "x" ) or "" ) .. " " or "" ) .. itemName:upper() .. "\n"
    end

    LocalPlayer()._dHeistsLootItems = lootString
end )

net.Receive( "dHeists.dropBag", function()
    LocalPlayer()._dHeistsBag = nil
    LocalPlayer()._dHeistsLootItems = nil
    dHeists.addedHeight = 0
end )

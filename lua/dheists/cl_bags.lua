--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

hook.Add( "PlayerButtonDown", "dHeists.dropBag", function( player, buttonId )
    if player ~= LocalPlayer() then return end
    if IsFirstTimePredicted() then return end

    if buttonId ~= dHeists.config.dropBagKey then return end

    RunConsoleCommand( "dheists_dropbag" )
end )

local roll = 0
hook.Add( "CalcView", "dHeists.drawBag", function( player, origin, angles, fov )
    if roll ~= 0 or ( roll == 0 and player:GetNW2Bool( "dHeists_CarryingBag", false ) ) then
        roll = Lerp( FrameTime() * 10, roll, player:GetNW2Bool( "dHeists_CarryingBag", false ) and dHeists.config.holdingBagAngleOffset or 0)

        local view = {
            origin = origin,
            angles = Angle( angles.p, angles.y, angles.r + roll )
        }

        return view
    end
end )

surface.CreateFont( "dHeists_bagText", {
    font = "Roboto Condensed",
    weight = 800,
    size = 26,
} )

local hudX, hudY = ScrW() - 4, ScrH() * 0.6
local width, height = 230, 70

local throwText =  "[" .. "G" .. "] TO THROW"
local carryingText = "CARRYING:"

local posMult = 0
hook.Add( "HUDPaint", "dHeists.drawBag", function()
    if posMult ~= 0 or ( posMult == 0 and LocalPlayer():GetNW2Bool( "dHeists_CarryingBag", false ) ) then
        posMult = Lerp( FrameTime() * 20, posMult, LocalPlayer():GetNW2Bool( "dHeists_CarryingBag", false ) and 1 or 0 )

        local offset = ( width * 1 ) / posMult

        surface.DrawCuteRect( hudX - offset, hudY, width, height, 3, 100 )

        draw.SimpleText( throwText, "dHeists_bagText", hudX + width + 2 - offset, hudY - 26, Color( 0, 0, 0, 185 ), TEXT_ALIGN_RIGHT )
        draw.SimpleText( throwText, "dHeists_bagText", hudX + width - offset, hudY - 28, Color( 240, 240, 240, 255 ), TEXT_ALIGN_RIGHT )

        draw.SimpleText( carryingText, "dHeists_bagText", hudX + 10 - offset, hudY + 8, Color( 0, 0, 0, 185 ) )
        draw.SimpleText( carryingText, "dHeists_bagText", hudX + 8 - offset, hudY + 6, color_white )

        draw.SimpleText( "BAG OF CASH", "dHeists_bagText", hudX + 8 - offset, hudY + 36, Color( 0, 0, 0, 185 ) )
        draw.SimpleText( "BAG OF CASH", "dHeists_bagText", hudX + 6 - offset, hudY + 34, color_white )
    end
end )
--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

dHeists.cctv = dHeists.cctv or {}

net.Receive( "dHeists_ViewCCTV", function( _ )
    local tvEntity = net.ReadEntity()
    local zoneId = tvEntity:GetZoneID()

    local frame = vgui.Create( "dHeists_CCTVFrame" )
    frame:Setup( zoneId )
end )

local segmentWidth = 32
function dHeists.cctv.drawCameraHUD( panel, name, pos, ang, w, h )
    panel.offset = name and ( panel.offset or 0 ) or ( panel.offset or 0 ) - 0.5

    surface.SetFont( "dHeistsLarge" )

    local text = name or "No Camera Connected"
    local width, height = surface.GetTextSize( text )

    local segmentHeight = 16

    draw.SimpleText( text, "dHeistsLarge", w / 2, segmentHeight * 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

    surface.SetDrawColor( name and Color( 50, 100, 50, 255 ) or Color( 100, 100, 100, 255 ) )
    surface.DrawRect( 0, 0, w, segmentHeight )
    surface.DrawRect( 0, h - segmentHeight, w, segmentHeight )
    surface.SetDrawColor( 20, 20, 20, 255 )

    segmentWidth = Lerp( FrameTime() * 6, segmentWidth or 32, name and 0 or 32 )

    for i = 1, ( w / segmentHeight ) * 3 do
        surface.DrawRect( i * 64 + panel.offset - 62, 0, segmentWidth, segmentHeight )
        surface.DrawRect( i * 64 + panel.offset - 62, h - segmentHeight, segmentWidth, segmentHeight )
    end

    if panel.offset < - width * 2 then
        panel.offset = 0
    end
end
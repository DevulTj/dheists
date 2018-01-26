--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

hook.Add( "PostDrawOpaqueRenderables", "dHeists.zones", function()
    if not dHeists.config.debugEnabled then return end

    render.SetColorMaterial()

	for zoneName, zoneInfo in pairs( dHeists.zones:getZones() or {} ) do
        local color = Color( 200, 50, 50, 255 )
        render.DrawWireframeBox( zoneInfo.origin, Angle( 0, 0, 0 ), zoneInfo.mins, zoneInfo.maxs, color, true )
    end
end )

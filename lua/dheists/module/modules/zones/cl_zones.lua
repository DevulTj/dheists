--[[
    © 2017 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

hook.Add( "PostDrawOpaqueRenderables", "dHeists.zones", function()
    if not dHeists.config.debugEnabled then return end

    render.SetColorMaterial()

	for sName, tData in pairs( dHeists.zones.list ) do
        local color = Color( 200, 50, 50, 255 )

        render.DrawWireframeBox( tData.origin, Angle( 0, 0, 0 ), tData.mins, tData.maxs, color, true )
    end
end )

--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

local DEBUG_ENABLED = "dheists_debug_mode"
local debugEnabled = CreateConVar( DEBUG_ENABLED, 0, FCVAR_ARCHIVE )

local function setDebugEnabled( val )
    val = tobool( val )
    dHeists.config.debugEnabled = LocalPlayer():IsAdmin() and val or false
end

hook.Add( "InitPostEntity", "dHeists.debug", function()
    setDebugEnabled( debugEnabled:GetBool() )
end )

cvars.AddChangeCallback( DEBUG_ENABLED, function( convarName, oldValue, newValue )
    setDebugEnabled( newValue )
end )

local function drawDebugESP()

end

hook.Add( "HUDPaint", "dHeists.debug", function()
    if dHeists.config.debugEnabled then
        draw.SimpleTextOutlined( "[dHeists] Debug Mode", "dHeists_bagTextLargeItalics", ScrW() / 2, ScrH() * 0.015, color_white, TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0, 100 ) )
        draw.SimpleTextOutlined( "ACTIVE", "dHeistsHuge", ScrW() / 2, ScrH() * 0.015 + 24, Color( 50, 200, 50 ), TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0, 100 ) )
    
        drawDebugESP()
    end

    for _, entity in pairs( ents.GetAll() ) do
        if entity.IsDHeistsEnt then
            local entityPos = entity:GetPos()
            local data = entityPos:ToScreen()

            draw.SimpleTextOutlined( "[DEBUG] " .. entity:getDevString( "entityType", "Spawned Entity" ), "dHeists_bagTextItalics", data.x, data.y, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0, 100 ) )
        end
    end
end )
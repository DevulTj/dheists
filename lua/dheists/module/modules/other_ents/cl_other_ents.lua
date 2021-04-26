--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

net.Receive( "dHeists_entUse", function( len )
    local entType = net.ReadString()
    local entData = dHeists.ent.list[ entType ]
    if not entData then return end

    if entData.useFunc then entData.useFunc() end
end )


hook.Add( "HUDPaint", "dHeists.drawNotSaved", function()
    CAMI.PlayerHasAccess( LocalPlayer(), dHeists.privileges.SPAWN_ENTITIES, function( hasAccess )
        if not hasAccess then return end

        local foundEnts = ents.FindInSphere( LocalPlayer():GetPos(), 300 )

        for _, entity in pairs( foundEnts ) do
            if entity:getDevBool( "notSaved", false ) then

                local entityPos = entity:GetPos()
                local data = entityPos:ToScreen()

                draw.SimpleTextOutlined( entity:getDevString( "entityType", "Spawned Entity" ), "dHeists_bagTextItalics", data.x, data.y, Color( 50, 200, 50 ), TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0, 100 ) )
                draw.SimpleTextOutlined( dL "save_instructions", "dHeists_bagTextSmaller", data.x, data.y + 24, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0, 100 ) )
            end
        end
    end )
end )

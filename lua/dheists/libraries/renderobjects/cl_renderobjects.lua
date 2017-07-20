--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

renderObjects = renderObjects or {}
renderObjects.objectList = renderObjects.objectList or {}

net.Receive( "renderObjects.loadObjects", function()
    renderObjects:setObjects( net.ReadTable() )

    renderObjects:render()
end )

net.Receive( "renderObjects.setObject", function()
    local player = Entity( net.ReadUInt( 16 ) )
    if not IsValid( player ) then return end

    renderObjects:setObject( player, net.ReadString() )
    renderObjects:render()
end )

net.Receive( "renderObjects.clearObject", function()
    local player = Entity( net.ReadUInt( 16 ) )
    if not IsValid( player ) then return end
    
    renderObjects:clearObject( player, net.ReadString() )
    renderObjects:render()
end )

function renderObjects:iterObjects()
    return pairs( self:getObjects() )
end

function renderObjects:setObjectEntity( player, objectName, objectEntity )
    self.objectList[ player:EntIndex() ][ objectName ] = objectEntity 
end

function renderObjects:clearEntity( objectName )
    local entity = self.objectList[ objectName ]

    if IsValid( entity ) then
        SafeRemoveEntity( entity )
    end
end

function renderObjects:render()
    for entIndex, objects in self:iterObjects() do
        for objectName, entity in pairs( objects ) do
            local objectData = self:getRegisteredObject( objectName )
            if not objectData then continue end -- TODO: mark for deletion

            local player = Entity( entIndex )
            if not IsValid( player ) then continue end -- TODO: mark for player deletion

            if not IsEntity( entity ) or not IsValid( entity ) then
                local objectEntity = ClientsideModel( objectData.model, RENDERGROUP_TRANSLUCENT )
                objectEntity:SetParent( player )

                if objectData.scale then objectEntity:SetModelScale( objectData.scale, 0 ) end
                if objectData.skin then print("Set skin of object", objectData.skin) objectEntity:SetSkin( objectData.skin ) end

                objectEntity:SetNoDraw( true )
                self:setObjectEntity( player, objectName, objectEntity )
            else
                local bone = player:LookupBone( objectData.bone or "ValveBiped.Bip01_Head1" )
                if bone then
                    local position, angles = player:GetBonePosition( bone )

                    angles:RotateAroundAxis( angles:Up(), objectData.ang.p )
					angles:RotateAroundAxis( angles:Right(), objectData.ang.y )
					angles:RotateAroundAxis( angles:Forward(), objectData.ang.r )

					local newPosition = position + angles:Forward() * objectData.pos.x
                    + angles:Right() * objectData.pos.y + angles:Up() * objectData.pos.z

                    entity:SetPos( newPosition )
					entity:SetAngles( angles )
					entity:DrawModel()
                end
            end
        end
    end
end

hook.Add( "PostPlayerDraw", "renderObjects.render", function()
    renderObjects:render()
end )

hook.Add( "renderObjects.clearObject", "renderObjects.clearObject", function( player, objectName )
    local entIndex = player:EntIndex()
    local entity = renderObjects:getObjects()[ entIndex ][ objectName ]

    renderObjects:clearEntity( objectName )
end )

hook.Add( "renderObjects.clearPlayer", "renderObjects.clearPlayer", function( player )
    local entIndex = player:EntIndex()
    for objectName, entity in pairs( renderObjects:getObjects()[ entIndex ] ) do
        renderObjects:clearEntity( objectName )
    end
end )
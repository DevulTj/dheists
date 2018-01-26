--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

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
                if objectData.skin then objectEntity:SetSkin( objectData.skin ) end

                objectEntity:SetNoDraw( true )

                self:setObjectEntity( player, objectName, objectEntity )
            else

                local position, angles
                local bone
                if objectData.bone then
                    bone = player:LookupBone( objectData.bone )

                    position, angles = player:GetBonePosition( bone )
                end

                if not position then position = player:GetPos() end
                if not angles then angles = Angle( 0, 0, 0 ) end

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

function renderObjects:renderEntity( player, playerOverride )
    local objects = self:getObjects()[ player:EntIndex() ]
    if not objects then return end

    for objectName, entity in pairs( objects ) do
        local objectData = self:getRegisteredObject( objectName )
        if not objectData then continue end -- TODO: mark for deletion

        if not IsValid( player ) then continue end -- TODO: mark for player deletion

        local target = playerOverride or player

        if not entity or isbool( entity ) or not IsValid( entity ) then
            local objectEntity = ClientsideModel( objectData.model, RENDERGROUP_TRANSLUCENT )
            if not IsValid( objectEntity ) then return end
            objectEntity:SetParent( target )

            if objectData.scale then objectEntity:SetModelScale( objectData.scale, 0 ) end
            if objectData.skin then objectEntity:SetSkin( objectData.skin ) end

            objectEntity:SetNoDraw( true )

            self:setObjectEntity( player, objectName, objectEntity )
        else

            local position, angles
            local bone = target:LookupBone( objectData.bone or "ValveBiped.Bip01_Head1" )
            position, angles = target:GetBonePosition( bone )

            if not bone then return end

            if not position then position = target:GetPos() end
            if not angles then angles = Angle( 0, 0, 0 ) end

            local ismale = player.IsMale and player:IsMale() or true
            local malePos = objectData.pos.male
            local femalePos = objectData.pos.female
            local desiredPos = ismale and malePos or femalePos or objectData.pos

            local maleAng = objectData.ang.male
            local femaleAng = objectData.ang.female
            local desiredAng = ismale and maleAng or femaleAng or objectData.ang

            angles:RotateAroundAxis( angles:Up(), desiredAng.p )
            angles:RotateAroundAxis( angles:Right(), desiredAng.y )
            angles:RotateAroundAxis( angles:Forward(), desiredAng.r )

            local newPosition = position + angles:Forward() * desiredPos.x
            + angles:Right() * desiredPos.y + angles:Up() * desiredPos.z

            entity:SetPos( newPosition )
            entity:SetAngles( angles )
            entity:DrawModel()
        end
    end
end


hook.Add( "PostPlayerDraw", "renderObjects.render", function( player )
    if GetViewEntity() == player then return end
    if player:GetNoDraw() then return end

    renderObjects:renderEntity( player )
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

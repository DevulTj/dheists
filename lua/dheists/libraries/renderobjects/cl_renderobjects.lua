--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify
	without permission of its author (devultj@gmail.com) - {{ user_id }}
]]

renderObjects = renderObjects or {}
renderObjects.objectList = renderObjects.objectList or {}

net.Receive( "renderObjects.loadObjects", function()
    renderObjects:setObjects( net.ReadTable() )
end )

net.Receive( "renderObjects.setObject", function()
    local player = net.ReadEntity()
    if not IsValid( player ) then return end

    renderObjects:setObject( player, net.ReadString() )
end )

net.Receive( "renderObjects.setObjectsOfPlayer", function()
    local player = net.ReadEntity()
    if not IsValid( player ) then return end

    renderObjects:setObjectsOfPlayer( player, net.ReadTable() )
end )

net.Receive( "renderObjects.clearObject", function()
    local player = net.ReadEntity()
    if not IsValid( player ) then return end

    renderObjects:clearObject( player, net.ReadString() )
end )

net.Receive( "renderObjects.clearPlayer", function()
    local player = net.ReadEntity()
    if not IsValid( player ) then return end

    renderObjects:clearPlayer( player )
end )

function renderObjects:iterObjects()
    return pairs( self:getObjects() )
end

function renderObjects:setObjectEntity( player, objectName, objectEntity )
    if not IsValid( player ) or not objectName or not objectEntity then return end

    self.objectList[ player ] = self.objectList[ player ] or {}
    self.objectList[ player ][ objectName ] = objectEntity
end

function renderObjects:clearEntity( player )
    local entity = self.objectList[ player ]

    self.objectList[ player ] = nil
end

function renderObjects:renderEntity( player, playerOverride )
    local objects = self:getObjects()[ player ]
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
            local malePos = objectData.pos and objectData.pos.male
            local femalePos = objectData.pos and objectData.pos.female
            local desiredPos = ismale and malePos or femalePos or objectData.pos

            local maleAng = objectData.ang and objectData.ang.male
            local femaleAng = objectData.ang and objectData.ang.female
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

if not dHeists.config.disablePlayerDrawHook then
    hook.Add( "PostPlayerDraw", "renderObjects.Draw", function( player )
        if GetViewEntity() == player then return end
        if player:GetNoDraw() then return end

        renderObjects:renderEntity( player )
    end )
end

hook.Add( "renderObjects.clearPlayer", "renderObjects.clearPlayer", function( player )
    for objectName, entity in pairs( renderObjects:getObjects()[ player ] ) do
        renderObjects:clearEntity( player, objectName )
    end
end )
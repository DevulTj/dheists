
HeistZone = {}
HeistZone.__index = HeistZone

HEIST_ZONE_ID = 0

function HeistZone:new( data )
    local zone = {
        bounds = {
            mins = data.mins,
            maxs = data.maxs
        },

        objects = {},
        spawnedObjects = {},
        spawnedAlarms = {},

        cooldownTime = data.cooldownTime or 60
    }

    -- Assign a zone ID
    HEIST_ZONE_ID = HEIST_ZONE_ID + 1
    zone.id = HEIST_ZONE_ID

    table.Merge( zone, data )

    return setmetatable( zone, HeistZone )
end

function HeistZone:getId()
    return self.id
end

function HeistZone:__tostring()
    return "[HeistZone][" .. self:getId() .. "]"
end

function HeistZone:getObjects()
    return self.entities
end

function HeistZone:addEntity( entity )
    self.spawnedObjects[ entity ] = true
end

function HeistZone:removeEntity( entity )
    self.spawnedObjects[ entity ] = nil
end

function HeistZone:addAlarm( alarm )
    self.spawnedAlarms[ alarm ] = true
end

function HeistZone:removeAlarm( alarm )
    self.spawnedAlarms[ alarm ] = nil
end

function HeistZone:spawnEntities()
    for i = 1, #self.objects do
        local typeInfo = self.objects[ i ]
        if not typeInfo then continue end

        local entity = ents.Create( "dheists_rob_ent_base" )

        entity:SetPos( typeInfo.pos )

        if typeInfo.ang then
            entity:SetAngles( typeInfo.ang )
        end

        dHeists.print( "Spawning " .. typeInfo.type .. ", " .. tostring( typeInfo.pos ) .. ", " .. tostring( typeInfo.ang or Angle( 0, 0, 0 ) ) )

        self:addEntity( entity )

        entity:Spawn()
        entity:Activate()

        entity:setEntityType( typeInfo.type )
        entity:setZone( self )

        entity:GetPhysicsObject():Sleep()
    end

    for i = 1, #self.alarms do
        local typeInfo = self.alarms[ i ]
        if not typeInfo then continue end

        local alarm = ents.Create( typeInfo.type or "dheists_alarm_base" )
        if not IsValid( alarm ) then continue end

        alarm:SetPos( typeInfo.pos )

        if typeInfo.ang then
            alarm:SetAngles( typeInfo.ang )
        end

        dHeists.print( "Spawning " .. typeInfo.type .. ", " .. tostring( typeInfo.pos ) .. ", " .. tostring( typeInfo.ang or Angle( 0, 0, 0 ) ) )

        self:addAlarm( alarm )

        alarm:Spawn()
        alarm:Activate()

        alarm:setZone( self )   

        alarm:GetPhysicsObject():Sleep()
    end
end

function HeistZone:startAlarm()
    for alarm, _ in pairs( self.spawnedAlarms ) do
    print(alarm)
        alarm:activate()
    end
end

function HeistZone:destroyEntities()
    for entity, _ in pairs( self.spawnedEntities ) do
        if IsValid( entity ) then
            SafeRemoveEntity( entity )
        end

        self:removeEntity( entity )
    end

    for alarm, _ in pairs( self.spawnedAlarms ) do
        if IsValid( alarm ) then
            SafeRemoveEntity( alarm )
        end

        self:removeAlarm( alarm )
    end
end

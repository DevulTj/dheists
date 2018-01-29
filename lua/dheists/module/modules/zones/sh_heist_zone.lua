
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

function HeistZone:getName()
    return self.name
end

function HeistZone:setName( name )
    self.name = name
end

function HeistZone:addEntity( key, entity )
    self.spawnedObjects[ key ] = self.spawnedObjects[ key ] or {}
    self.spawnedObjects[ key ][ entity ] = true

    entity._entityIdentifier = key
end

function HeistZone:removeEntity( key, entity )
    self.spawnedObjects[ key ][ entity ] = nil
end

function HeistZone:spawnEnt( class, pos, ang )
    local entity = ents.Create( class )
    entity:SetPos( pos )
    entity:SetAngles( ang or Angle( 0, 0, 0 ) )

    entity:Spawn()
    entity:Activate()

    entity:GetPhysicsObject():EnableMotion( false )

    dHeists.print( "Spawning " .. class .. ", " .. tostring( pos ) .. ", " .. tostring( ang or Angle( 0, 0, 0 ) ) )

    entity:setZone( self )

    return entity
end

function HeistZone:spawnEntities()
    if self.objects then
        for i = 1, #self.objects do
            local typeInfo = self.objects[ i ]
            if not typeInfo then continue end

            local entity = self:spawnEnt( "dheists_rob_ent_base", typeInfo.pos, typeInfo.ang )
            entity:setEntityType( typeInfo.type )
            self:addEntity( "objects", entity )
        end
    end

    if self.alarms then
        for i = 1, #self.alarms do
            local typeInfo = self.alarms[ i ]
            if not typeInfo then continue end

            local alarm = self:spawnEnt( typeInfo.type or "dheists_alarm_base", typeInfo.pos, typeInfo.ang )
            self:addEntity( "alarms", alarm )
        end
    end

    if self.cameras then
        for i = 1, #self.cameras do
            local typeInfo = self.cameras[ i ]
            if not typeInfo then continue end

            local camera = self:spawnEnt( typeInfo.type, typeInfo.pos, typeInfo.ang )
            self:addEntity( "cameras", camera )
            camera:SetCameraName( typeInfo.name or ( self:getName() .. " #" .. i ) )
        end
    end

    if self.tvs then
        for i = 1, #self.tvs do
            local typeInfo = self.tvs[ i ]
            if not typeInfo then continue end

            local tv = self:spawnEnt( "dheists_cctv_tv_base", typeInfo.pos, typeInfo.ang )
            self:addEntity( "tvs", tv )
        end
    end
end

function HeistZone:startAlarm()
    for alarm, _ in pairs( self.spawnedObjects and self.spawnedObjects.alarms ) do
        alarm:activate()
    end
end

function HeistZone:recursiveDelete( tbl )
    for k, v in pairs( tbl ) do
        if type( v ) == "table" then self:recursiveDelete( v ) continue end
        if IsValid( k ) then
            self.spawnedObjects[ k._entityIdentifier ][ k ] = nil
            SafeRemoveEntity( k )
            
            continue 
        end
    end
end

function HeistZone:destroyEntities()
    self:recursiveDelete( self.spawnedObjects )
end


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
    -- Check for heist objects i.e robbable ents
    if self.objects then
        for i = 1, #self.objects do
            local typeInfo = self.objects[ i ]
            if not typeInfo then continue end

            local entity = self:spawnEnt( "dheists_rob_ent_base", typeInfo.pos, typeInfo.ang )
            entity:setEntityType( typeInfo.type )
            self:addEntity( "objects", entity )
        end
    end

    -- Check for alarms
    if self.alarms then
        for i = 1, #self.alarms do
            local typeInfo = self.alarms[ i ]
            if not typeInfo then continue end

            local alarm = self:spawnEnt( typeInfo.type or "dheists_alarm_base", typeInfo.pos, typeInfo.ang )
            self:addEntity( "alarms", alarm )

            -- Custom alarm sounds
            if self.alarmSound then alarm:setAlarmSound( "alarm_" .. i, self.alarmSound, self.alarmSoundData ) end
            -- Custom alarm durations
            if self.alarmDuration then alarm.alarmDuration = self.alarmDuration end
        end
    end

    -- Check for cameras
    if self.cameras then
        for i = 1, #self.cameras do
            local typeInfo = self.cameras[ i ]
            if not typeInfo then continue end

            local camera = self:spawnEnt( typeInfo.type, typeInfo.pos, typeInfo.ang )
            self:addEntity( "cameras", camera )

            -- Set camera names if custom or fall back
            camera:SetCameraName( typeInfo.name or ( self:getName() .. " #" .. i ) )
        end
    end

    -- Check for TVs
    if self.tvs then
        for i = 1, #self.tvs do
            local typeInfo = self.tvs[ i ]
            if not typeInfo then continue end

            local tv = self:spawnEnt( "dheists_cctv_tv_base", typeInfo.pos, typeInfo.ang )
            self:addEntity( "tvs", tv )

            tv:SetZoneName( self:getName() )
        end
    end

    -- Check for tripwires
    if self.tripwires then
        for i = 1, #self.tripwires do
            local typeInfo = self.tripwires[ i ]
            if not typeInfo then continue end

            self:addEntity( "tripwires", self:spawnEnt( "dheists_tripwire_alarm_base", typeInfo.pos, typeInfo.ang ) )
        end
    end

    -- Check for screens
    if self.screens then
        for i = 1, #self.screens do
            local typeInfo = self.screens[ i ]
            if not typeInfo then continue end

            local screen = self:spawnEnt( "dheists_zone_screen_base", typeInfo.pos, typeInfo.ang )
            self:addEntity( "screens", screen )
            
            screen:SetZoneName( self:getName() )
        end
    end

    -- Check for screens
    if self.alarmButtons then
        for i = 1, #self.alarmButtons do
            local typeInfo = self.alarmButtons[ i ]
            if not typeInfo then continue end

            self:addEntity( "alarmButtons", self:spawnEnt( "dheists_alarm_button", typeInfo.pos, typeInfo.ang ) )
        end
    end
end

function HeistZone:startAlarm()
    for alarm, _ in pairs( self.spawnedObjects and self.spawnedObjects.alarms or {} ) do
        alarm:activate()
    end

    for _, player in pairs( self:getPoliceMembers() ) do
        dHeists.gamemodes:notify( player, i18n.getPhrase( "zone_being_robbed", self:getName() ) )
    end

    for screen, _ in pairs( self.spawnedObjects and self.spawnedObjects.screens or {} ) do
        screen:SetCooldownEnd( CurTime() + ( 60 * 60 ) )
    end
end

function HeistZone:stopAlarm()
    for tripwire, _ in pairs( self.spawnedObjects and self.spawnedObjects.tripwires or {} ) do
        tripwire:deActivate()
    end
end


function HeistZone:deActivateAlarms()
    for alarm, _ in pairs( self.spawnedObjects and self.spawnedObjects.alarms or {} ) do
        alarm:deActivate()
    end
end

function HeistZone:combineCategores()
    self.teams = {}

    if not self.jobCategories then return end

    for teamIndex, jobData in pairs( dHeists.gamemodes:getJobList() or {} ) do
        if self.jobCategories[ jobData[ dHeists.gamemodes:getCategoryIndex() ] ] then
            self.teams[ teamIndex ] = true
        end
    end
end

function HeistZone:getPoliceMembers()
    local players = {}

    for teamIndex, _ in pairs( self.teams or {} ) do
        table.Add( players, team.GetPlayers( teamIndex ) )
    end

    return players
end

function HeistZone:getPoliceCount()
    local players = 0

    for teamIndex, _ in pairs( self.teams or {} ) do
        players = players + #team.GetPlayers( teamIndex )
    end

    return players
end

function HeistZone:isRequiredPoliceCount()
    return self:getPoliceCount() >= ( self.minJobOnlineForRobbery or 0 )
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

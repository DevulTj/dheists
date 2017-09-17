
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
        entities = {}
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
    return table.insert( self.entities, entity )
end

function HeistZone:removeEntity( index )
    return table.remove( self.entities, index )
end

function HeistZone:spawnEntities()
    for i = 1, #self.objects do
        local typeInfo = self.objects[ i ]
        if not typeInfo then continue end

        local eEnt = ents.Create( "dheists_rob_ent_base" )

        eEnt:SetPos( typeInfo.pos )

        if typeInfo.ang then
            eEnt:SetAngles( typeInfo.ang )
        end

        eEnt:setEntityType( typeInfo.type )

        dHeists.print( "Spawning " .. typeInfo.type .. ", " .. tostring( typeInfo.pos ) .. ", " .. tostring( typeInfo.ang or Angle( 0, 0, 0 ) ) )

        self:addEntity( eEnt )
    end
end

function HeistZone:setCooldown( cooldownTime )
    self.nextUse = CurTime() + cooldownTime

    return self.nextUse
end

function HeistZone:getCooldown()
    return self.nextUse or 0
end

function HeistZone:resetCooldown()
    self.nextUse = nil
end

function HeistZone:destroyEntities()
    for index = 1, #self.entities do
        local entity = self.entities[ index ]

        if IsValid( entity ) then
            SafeRemoveEntity( entity )
        end

        self:removeEntity( index )
    end
end

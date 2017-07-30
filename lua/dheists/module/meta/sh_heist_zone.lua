
HeistZone = {}
HeistZone.__index = HeistZone

HEIST_ZONE_ID = 0

function HeistZone:new( mins, maxs, data )
    local zone = {
        bounds = {
            mins = mins,
            maxs = maxs
        },

        objects = {}
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
    return self.objects
end

function HeistZone:addObject( entity )
    return table.insert( self.objects, entity )
end

function HeistZone:removeObject( index )
    return table.remove( self.objects, index )
end

function HeistZone:setCooldown( cooldownTime )
    self.nextUse = CurTime() + cooldownTime

    return self.nextUse
end

function HeistZone:resetCooldown()
    self.nextUse = nil
end

function HeistZone:destroyObjects()
    for index = 1, #self.objects do
        local entity = self.objects[ index ]

        if IsValid( entity ) then
            SafeRemoveEntity( entity )
        end

        self:removeObject( index )
    end
end

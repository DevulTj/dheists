
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
        entities = {},

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

        dHeists.print( "Spawning " .. typeInfo.type .. ", " .. tostring( typeInfo.pos ) .. ", " .. tostring( typeInfo.ang or Angle( 0, 0, 0 ) ) )

        self:addEntity( eEnt )

        eEnt:Spawn()
        eEnt:Activate()

        eEnt:setEntityType( typeInfo.type )
        eEnt:setZone( self )
    end
end

local TIMER_NAME = "HeistZone_%i_Timer"
function HeistZone:activate()
    if self:getRobberyActive() then return end
    
    self:setRobberyActive( true )
    self.deActivationTime = CurTime() + dHeists.config.robberyTime

    print( "Heist Started" )
    
    timer.Create( TIMER_NAME:format( self:getId() ), dHeists.config.robberyTime, 1, function()
        self:setRobberyActive( false )
        self.deActivationTime = nil

        self.nextActivation = CurTime() + self.cooldownTime

        print( "Heist Ended" )
    end )
end

function HeistZone:canRob()
    return self.nextActivation == nil or self.nextActivation < CurTime()
end

function HeistZone:setRobberyActive( bool )
    self.isActive = bool
end

function HeistZone:getRobberyActive()
    return self.isActive
end

function HeistZone:getCooldownTime()
    return self.cooldownTime or 0
end

function HeistZone:destroyEntities()
    for index, entity in pairs( self.entities ) do
        if IsValid( entity ) then
            SafeRemoveEntity( entity )
        end

        self:removeEntity( index )
    end
end

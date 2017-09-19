--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ENT = {}

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Robbable Entity"
ENT.Category = "dHeists"

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsRobbableEntity = true

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "EntityType" )
    self:NetworkVar( "Entity", 0, "Drill" )
    self:NetworkVar( "Int", 0, "Zone" )
end

if SERVER then
    function ENT:Initialize()
        -- assign a default model, with physics etc.

        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )

        local randomEntData = table.Random( dHeists.robbing.list )
        if not randomEntData then
            SafeRemoveEntity( self )

            return
        end

        self:setEntityType( randomEntData )
    end

    function ENT:setEntityType( entType )
        local entData = istable( entType ) and entType or dHeists.robbing.getEnt( entType )
        if not entData then return end

        self:SetEntityType( entData.name )
        self:SetModel( entData.model )

        if entData.material then self:SetMaterial( entData.material ) end

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )

        self:GetPhysicsObject():Wake()

        if entData.lootSpawnPoint then
            self.lootSpawnPoint = entData.lootSpawnPoint
        end

        self:SetMaterial( "" )

        self.lootItems = entData.loot
    end

    function ENT:deploy()
        local lootItems = self.lootItems
        local randomItem = lootItems[ math.random( 1, #lootItems ) ]

        local lootData = dHeists.loot.getLoot( randomItem )
        if not lootData then return end

        local entity = ents.Create( "dheists_loot_base" )
        entity:SetPos( self:LocalToWorld( self.lootSpawnPoint or Vector( 0, 0, 0 ) ) )

        entity:Spawn()
        entity:Activate()

        entity:setLootType( randomItem )

        if self.typeInfo then
            self.typeInfo.onFinish( self, entity )
        end
    end

    function ENT:getZone()
        return dHeists.zones and dHeists.zones.zones[ self:GetZone() ]
    end

    function ENT:canDeploy( player )
        if self:getZone() then
            local zone = self:getZone()

            if zone:getCooldown() and zone:getCooldown() > CurTime() then
                dHeists.addNotification( player, "Cooldown is active" )
                return false
            end
        end

        if IsValid( self:GetDrill() ) then
            local drill = self:GetDrill()
            if drill:isFinished() then
                return true
            else
                dHeists.addNotification( player, "Drill is active" )
                return false
            end
        end

        return false
    end

    function ENT:setDrill( drillEnt )
        if not self.GetEntityType then return end

        if self.GetDrill and IsValid( self:GetDrill() ) then return end -- Disallow more than one drill on an entity at once.

        local typeInfo = dHeists.robbing.getEnt( self:GetEntityType() )
        if not typeInfo then return end

        self.typeInfo = typeInfo

        drillEnt:SetParent( self )
        drillEnt:SetPos( typeInfo.drillPos )

        local localAng = self:LocalToWorldAngles( typeInfo.drillAng or Angle( 0, 0, 0 ) )
        drillEnt:SetAngles( localAng )

        drillEnt:SetDrillStart( CurTime() )
        drillEnt:SetDrillEnd( CurTime() + 10 )

        self:SetDrill( drillEnt )
    end

    function ENT:removeDrill()
        if IsValid( self:GetDrill() ) then
            SafeRemoveEntity( self:GetDrill() )
        end
    end

    function ENT:Use( activator, player )
        print( player, "test?" )
        if not self:canDeploy( player ) then return end

        self:deploy()
        self:removeDrill()
    end
end

if CLIENT then
    function ENT:Draw()
    	self:DrawModel()

        local typeInfo = dHeists.robbing.getEnt( self:GetEntityType() )
        if not typeInfo then return end

        if dHeists.config.debugEnabled then
            local lootSpawnPos = typeInfo.lootSpawnPoint
            local entPos = self:GetPos()

            if lootSpawnPos then
                render.DrawLine( entPos, self:LocalToWorld( lootSpawnPos ), color_white )
                render.SetColorMaterial()
                render.DrawSphere( self:LocalToWorld( lootSpawnPos ), 10, 30, 30, Color( 255, 255, 255, 100 ) )
            end

            local drillPos = typeInfo.drillPos
            if drillPos then
                local drillVector = self:LocalToWorld( drillPos )
                    drillVector.z = drillVector.z + 1
                local direction = Vector( entPos.x - drillVector.x, entPos.y - drillVector.y, entPos.z - drillVector.z + 1 )

                render.DrawLine( drillVector, drillVector + direction, Color( 250, 50, 50, 150 ) )
                render.SetColorMaterial()
                render.DrawSphere( drillVector, 5, 30, 30, Color( 250, 50, 50, 150 ) )
            end
        end
    end

	function ENT:Initialize()
        self:DrawShadow( false )
	end
end

scripted_ents.Register( ENT, "dheists_rob_ent_base" )

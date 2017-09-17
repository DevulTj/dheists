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

        self.lootItems = entData.loot
    end

    function ENT:deploy()
        local lootItems = self.lootItems
        local randomItem = lootItems[ math.random( 1, #lootItems ) ]

        local lootData = dHeists.loot.getLoot( randomItem )
        if not lootData then return end

        local entity = ents.Create( "dheists_loot_base" )
        entity:SetPos( self:LocalToWorld( self.lootSpawnPoint or Vector( 0, 0, 0 ) ) )

        entity:setLootType( randomItem )

        entity:Spawn()
        entity:Activate()
    end

    function ENT:canDeploy()
        if IsValid( self:GetDrill() ) then
            local drill = self:GetDrill()
            if drill:isFinished() then return true end
        end

        return false
    end

    function ENT:removeDrill()
        if IsValid( self:GetDrill() ) then
            SafeRemoveEntity( self:GetDrill() )
        end
    end

    function ENT:Use()
        if not self:canDeploy() then return end

        self:deploy()
        self:removeDrill()
    end
end

if CLIENT then
    function ENT:Draw()
    	self:DrawModel()

        local tData = dHeists.robbing.getEnt( self:GetEntityType() )
        if not tData then return end

        if dHeists.config.debugEnabled then
            local lootSpawnPos = tData.lootSpawnPoint
            local entPos = self:GetPos()

            if lootSpawnPos then
                render.DrawLine( entPos, self:LocalToWorld( lootSpawnPos ), color_white )
                render.SetColorMaterial()
                render.DrawSphere( self:LocalToWorld( lootSpawnPos ), 10, 30, 30, Color( 255, 255, 255, 100 ) )
            end

            local drillPos = tData.drillPos
            if drillPos then
                local drillVector = self:LocalToWorld( drillPos )
                    drillVector.z = drillVector.z + 1
                local direction = Vector( entPos.x - drillVector.x, entPos.y - drillVector.y, entPos.z - drillVector.z + 1)

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

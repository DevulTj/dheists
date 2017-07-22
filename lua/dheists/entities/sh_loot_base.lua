--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ENT = {}

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Loot"
ENT.Category = "dHeists"

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsLoot = true

if SERVER then
    function ENT:SetupDataTables()
        self:NetworkVar( "String", 0, "LootType" )
    end

    function ENT:Initialize()
        -- assign a default model, with physics etc.

        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )

        local randomLootData = table.Random( dHeists.loot.list )
        if not randomLootData then
            SafeRemoveEntity( self )

            return
        end

        self:setLootType( randomLootData )
    end

    function ENT:setLootType( lootType )
        local lootData = istable( lootType ) and lootType or dHeists.loot.getLoot( lootType )
        if not lootData then return end

        self:SetLootType( lootData.name )
        self:SetModel( lootData.model )

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:GetPhysicsObject():Wake()
    end

    function ENT:Use( player )
        local bag = player:getBag()
        if not bag then return end

        --[[
            TODO: add data from entity into bag loot items
                  check if the bag is full already
        ]]

        SafeRemoveEntity( self )
    end

    function ENT:StartTouch( entity )
        if not entity.IsBag then return end

        local canDo = entity:addLoot( self:GetLootType() )

        if canDo ~= false then
            SafeRemoveEntity( self )
        end
    end
end

if CLIENT then
    function ENT:Draw()
    	self:DrawModel()
    end

	function ENT:Initialize()
        self:DrawShadow( false )
	end
end

scripted_ents.Register( ENT, "dheists_loot_base" )

--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ENT = {}

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Bag"

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsBag = true

if SERVER then
    function ENT:SetupDataTables()
        self:NetworkVar( "Int", 0, "BagType" )
    end

    function ENT:Initialize()
        local selectedModel = dHeists.config.bagModel
        local isValidModel = file.Exists( selectedModel, "GAME" )

        if not isValidModel then 
            selectedModel = "models/jessev92/payday2/item_Bag_loot.mdl"
        end

        self:SetModel( selectedModel )

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )

        self:SetBagType( 1 ) -- Bag types
    end

    function ENT:Use( player )
        dHeists.actions.doAction( player, dHeists.config.bagPickUpTime, function()
            SafeRemoveEntity( self )
        end, {
            ent = self
        } )
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

scripted_ents.Register( ENT, "dheists_bag_base" )
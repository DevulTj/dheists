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
        self:NetworkVar( "Int", 0, "LootType" )
    end

    function ENT:Initialize()
        -- assign a default model, with physics etc.
    end

    function ENT:setLootType( lootType )
        self:SetLootType( lootType )

        -- TODO: get loot type through some kind of table and assign models here
    end

    function ENT:Use( player )
        -- TODO: check if the player is holding a bag, if they are - add the loot into the bag
    end

    function ENT:StartTouch( entity )
        -- TODO: add an entity whitelist for bags so you can place loot into bags
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

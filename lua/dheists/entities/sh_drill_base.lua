--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ENT = {}

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Drill"

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsDrill = true

if SERVER then
    function ENT:Initialize()
        local selectedModel = dHeists.config.drillModel
        local isValidModel = file.Exists( selectedModel, "GAME" )

        if not isValidModel then 
            selectedModel = "models/devultj/drill.mdl"
        end

        self:SetModel( selectedModel )

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )
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

scripted_ents.Register( ENT, "dheists_drill_base" )
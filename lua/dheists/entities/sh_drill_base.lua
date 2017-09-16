--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ENT = {}

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Drill"
ENT.Category = "dHeists"

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.physicsBox = {
    mins = Vector( -7, -20, -5 ),
    maxs = Vector( 7, 10, 6 )
}

ENT.IsDrill = true

function ENT:Initialize()
    local selectedModel = dHeists.config.drillModel
    local isValidModel = file.Exists( selectedModel, "GAME" )

    if not isValidModel then
        selectedModel = "models/hunter/blocks/cube05x05x05.mdl"
    end

    self:SetModel( selectedModel )

    self:PhysicsInitBox( self.physicsBox.mins, self.physicsBox.maxs )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
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

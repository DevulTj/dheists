--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ENT = {}

ENT.Name = "Base NPC"
ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.Author = "DevulTj"
ENT.Category = "dHeists"
ENT.AutomaticFrameAdvance = false

ENT.IsBaseNPC = true

ENT.physicsBox = {
    mins = Vector( -7, -10, -0 ),
    maxs = Vector( 7, 10, 75 )
}

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "NPCType" )
end

if SERVER then
	AddCSLuaFile()

	function ENT:Initialize()
		self:SetModel( "models/gman_high.mdl" )
		self:SetHullType( HULL_HUMAN )
		self:SetHullSizeNormal()

        self:PhysicsInitBox( self.physicsBox.mins, self.physicsBox.maxs )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )

		self:SetMaxYawSpeed( 5000 )
		self:SetNotSolid( false )
		self:DropToFloor()

        self:SetTrigger( true )

        self:GetPhysicsObject():EnableMotion( false )
	end

    function ENT:setNPC( npcInfo )
        self:SetModel( npcInfo.model )

        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )

        self:PhysicsInitBox( self.physicsBox.mins, self.physicsBox.maxs )
        self:GetPhysicsObject():EnableMotion( false )

        self.startTouch = npcInfo.startTouch
        self:SetNPCType( npcInfo.name )
    end

	function ENT:AcceptInput( name, activator, caller )
		if name ~= "Use" or not IsValid( caller ) or not caller:IsPlayer() then return end

		hook.Call( "dHeists_NPCUsed", nil, self, name, activator, caller )
	end

    function ENT:StartTouch( entity )
        if self.startTouch then self.startTouch( self, entity ) end
    end

	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

        if dHeists.config.debugEnabled then
            render.DrawWireframeBox( self:GetPos(), self:GetAngles(), self.physicsBox.mins, self.physicsBox.maxs, color_white )
        end
	end

	local drawTextDistance = 160000
	hook.Add( "HUDPaint", "dHeists", function()
		local entity = LocalPlayer():GetEyeTrace().Entity
		if not IsValid( entity ) or not entity.IsBaseNPC or entity:GetPos():DistToSqr( LocalPlayer():GetPos() ) > drawTextDistance then return end

		local npcData = dHeists.npc.list[ entity:GetNPCType() ]
		if not npcData then return end

		local pos = entity:GetPos()
		pos.z = pos.z + 59
		pos = pos:ToScreen()

		draw.SimpleText( npcData.name, "dHeists_bagText", pos.x + 1, pos.y + 1, color_black, TEXT_ALIGN_CENTER )
		draw.SimpleText( npcData.name, "dHeists_bagText", pos.x, pos.y, color_white, TEXT_ALIGN_CENTER )
	end )
end

scripted_ents.Register( ENT, "dheists_npc_base" )

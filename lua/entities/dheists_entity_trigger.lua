--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Author = "Flixs"

ENT.PrintName = "Entity Trigger"
ENT.Category  = "dHeists"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.AutomaticFrameAdvance = false

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.DHeists = true

ENT.MODEL = "models/hunter/plates/plate1x2.mdl"

ENT._parent = nil

ENT.NEXT_TOUCH = .1
ENT._nextTouch = 0

function ENT:SpawnFunction( ply, tr, ClassName )
    if not tr.Hit then return end

    local SpawnPos = tr.HitPos + tr.HitNormal * 16

    local ent = ents.Create( ClassName )
    ent:SetPos( SpawnPos )
    ent:setDevEntity( "creator", ply )
    ent:Spawn()
    ent:Activate()

    return ent
end

function ENT:Initialize()
    if SERVER then
        self:SetModel( self.MODEL )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )
        self:DrawShadow( false )
    else
        local phys = self:GetPhysicsObject()
        if IsValid( phys ) then phys:EnableMotion( false ) end
    end
end

if SERVER then
    function ENT:OnTakeDamage()
        return false
    end

    function ENT:ShouldNotCollide( ent )
        if ent:IsValid() and ent:IsPlayer() then
            return true
        end

        return false
    end

    function ENT:StartTouch( ply )
        if not ply:IsPlayer() then return end

        self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

        timer.Simple( 120, function()
            if not IsValid( self ) then return end

            self:SetCollisionGroup( COLLISION_GROUP_NONE )
        end )

        local parent = self:GetParent()
        if not IsValid( parent ) then return end

        parent:TriggerAlarm( ply )
    end

    function ENT:SetTheParent( ent )
        self._parent = ent

        self:SetParent( ent )
    end

    function ENT:GetParent()
        return self._parent
    end
else
    function ENT:Draw() end
end

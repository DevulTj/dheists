--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Mask Base"
ENT.Category = "dHeists"

ENT.Spawnable = false
ENT.AdminSpawnable	= true

--[[
    MONOLITH RP INVENTORY VARIABLES
]]
ENT.IsItem = true
ENT.OwnerOnlyPickUp = false
ENT.WalkOnlyPickUp = true

ENT.IsMask = true
ENT.DHeists = true

ENT.MaskModel = "models/shaklin/payday2/masks/pd2_mask_dallas.mdl"
ENT.MaskPos = Vector( 1, 0, -3 )
ENT.MaskAng = Angle( 90, 180, 90 )

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "MaskType" )
end

function ENT:Initialize()
    -- assign a default model, with physics etc.

    if SERVER then
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )
    end

    self:setMaskType( self.PrintName, self.MaskModel, self.MaskPickUpTime )
end

function ENT:setMaskType( sName, sModel, nActionTime )
    if SERVER then
        self:SetMaskType( sName )
        self:SetModel( sModel )

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:GetPhysicsObject():Wake()

        self:SetUseType( SIMPLE_USE )
        self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

        self.actionTime = nActionTime or 1
    else
        self:DrawShadow( false )
    end

    self.InventoryItemID = sName
end

if SERVER then
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

    function ENT:Use( player )
        if player:KeyDown( IN_WALK ) then return end

        local canDo, reason = hook.Run( "dHeists.maskPickUp", player, self )
        if canDo == false then
            if reason then player:dHeistsNotify( reason, NOTIFY_GENERIC ) end

            return
        end

        dHeists.actions.doAction( player, self.actionTime or 1, function()
            local canDo, reason = player:addMask( self:GetClass() )
            if canDo ~= false then
                SafeRemoveEntity( self )
            else
                player:dHeistsNotify( reason or "You already have a mask", NOTIFY_ERROR )
            end
        end, {
            ent = self,
            ActionColor = dHeists.config.pickUpMaskActionColor,
            ActionTimeRemainingTextPhrase = "picking_up_mask"
        } )
    end
end

if CLIENT then
    function ENT:Draw()
    	self:DrawModel()
    end

    local drawTextDistance = 160000
	hook.Add( "HUDPaint", "dHeists.maskDraw", function()
		local entity = LocalPlayer():GetEyeTrace().Entity
		if not IsValid( entity ) or not entity.IsMask or entity:GetPos():DistToSqr( LocalPlayer():GetPos() ) > drawTextDistance then return end

		local pos = entity:GetPos()
		pos.z = pos.z + 10
		pos = pos:ToScreen()

		draw.SimpleText( entity.PrintName, "dHeists_bagText", pos.x + 1, pos.y + 1, color_black, TEXT_ALIGN_CENTER )
		draw.SimpleText( entity.PrintName, "dHeists_bagText", pos.x, pos.y, color_white, TEXT_ALIGN_CENTER )

        pos.y = pos.y + 20
	end )
end
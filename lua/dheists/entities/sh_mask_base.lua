--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ENT = {}

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Mask"
ENT.Category = "dHeists"

ENT.Spawnable = true
ENT.AdminSpawnable	= true

--[[
    MONOLITH RP INVENTORY VARIABLES
]]
ENT.IsItem = true
ENT.OwnerOnlyPickUp = false
ENT.WalkOnlyPickUp = true

ENT.IsMask = true
ENT.DHeists = true

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "MaskType" )
end

if SERVER then
    function ENT:Initialize()
        -- assign a default model, with physics etc.

        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )

        local randomMaskData = table.Random( dHeists.masks.list )
        if not randomMaskData then
            SafeRemoveEntity( self )

            return
        end

        self:setMaskType( randomMaskData )

        self:SetAutomaticFrameAdvance( false )
    end

    function ENT:setMaskType( maskType )
        local maskData = istable( maskType ) and maskType or dHeists.masks.getMask( maskType )
        if not maskData then return end

        self:SetMaskType( maskData.name )
        self:SetModel( maskData.model )

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:GetPhysicsObject():Wake()

        self:SetUseType( SIMPLE_USE )
        self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

        self.actionTime = maskData.actionTime

        self.InventoryItemID = maskType
    end

    function ENT:Use( player )
        if player:KeyDown( IN_WALK ) then return end

        local canDo, reason = hook.Run( "dHeists.maskPickUp", player, self )
        if canDo == false then
            if reason then player:dHeistsNotify( reason, NOTIFY_GENERIC ) end

            return
        end

        dHeists.actions.doAction( player, self.actionTime or 1, function()
            local maskType = self:GetMaskType()
            local canDo, reason = player:addMask( maskType )
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

		local maskData = dHeists.masks.list[ entity:GetMaskType() ]
		if not maskData then return end

		local pos = entity:GetPos()
		pos.z = pos.z + 10
		pos = pos:ToScreen()

		draw.SimpleText(dL( maskData.name ), "dHeists_bagText", pos.x + 1, pos.y + 1, color_black, TEXT_ALIGN_CENTER )
		draw.SimpleText(dL( maskData.name ), "dHeists_bagText", pos.x, pos.y, color_white, TEXT_ALIGN_CENTER )

        pos.y = pos.y + 20
	end )

	function ENT:Initialize()
        self:DrawShadow( false )
	end
end

scripted_ents.Register( ENT, "dheists_mask_base" )

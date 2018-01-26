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

ENT.IsMask = true

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

        self.actionTime = maskData.actionTime
    end

    function ENT:Use( player )
        dHeists.actions.doAction( player, self.actionTime or 1, function()
            local maskType = self:GetMaskType()
            local canDo, reason = player:addMask( maskType )
            if canDo ~= false then
                SafeRemoveEntity( self )
            else
                if reason then
                    frotify.notify( "You already have a Mask.", NOTIFY_ERROR, 4, player )
                end
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

	function ENT:Initialize()
        self:DrawShadow( false )
	end
end

scripted_ents.Register( ENT, "dheists_mask_base" )

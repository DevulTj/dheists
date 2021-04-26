--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Loot"
ENT.Category = "dHeists"

ENT.Spawnable = true
ENT.AdminSpawnable	= true
ENT.DHeists = true

ENT.IsLoot = true

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "LootType" )
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

        self:SetAutomaticFrameAdvance( false )
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

        self:SetUseType( SIMPLE_USE )

        self:SetTrigger( true )

        self.actionTime = lootData.actionTime
    end

    function ENT:Use( player )
        local bag = player:getBag()
        if not bag then player:dHeistsHint( dL "loot_hint_text", NOTIFY_ERROR ) return end

        dHeists.actions.doAction( player, self.actionTime or 0, function()
            if not player:getBag() then return end

            local canDo, reason = player:addLoot( self:GetLootType() )
            if canDo == false then
                player:dHeistsHint( reason or "You can't pick this up", NOTIFY_ERROR )

                return
            end

            SafeRemoveEntity( self )
        end, {
            ent = self,
            ActionColor = dHeists.config.pickUpLootActionColor,
            ActionTimeRemainingTextPhrase = dL( "picking_up_loot" )
        } )
    end

    function ENT:StartTouch( entity )
        if not entity.IsBag then print("Not a bag") return end

        print("touch", entity)

        local canDo = entity:addLoot( self:GetLootType() )
        if canDo ~= false then
            SafeRemoveEntity( self )
        end
    end
end

if CLIENT then
    local visibleDrawDistance = 1000000
    function ENT:Draw()
        if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) > visibleDrawDistance then return end

    	self:DrawModel()
    end

    local drawTextDistance = 160000
	hook.Add( "HUDPaint", "dHeists.loot", function()
		local entity = LocalPlayer():GetEyeTrace().Entity
		if not IsValid( entity ) or not entity.IsLoot or entity:GetPos():DistToSqr( LocalPlayer():GetPos() ) > drawTextDistance then return end

		local lootData = dHeists.loot.list[ entity:GetLootType() ]
		if not lootData then return end

		local pos = entity:GetPos()
		pos.z = pos.z + 10
		pos = pos:ToScreen()

		draw.SimpleText( dL( lootData.name ), "dHeists_bagText", pos.x + 1, pos.y + 1, color_black, TEXT_ALIGN_CENTER )
		draw.SimpleText( dL( lootData.name ), "dHeists_bagText", pos.x, pos.y, color_white, TEXT_ALIGN_CENTER )

        pos.y = pos.y + 20

        local worthText = dL( "loot_worth", string.formatMoney( lootData.moneyGiven ) )
		draw.SimpleText( worthText, "dHeists_bagTextItalics", pos.x + 1, pos.y + 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
		draw.SimpleText( worthText, "dHeists_bagTextItalics", pos.x, pos.y, Color( 100, 200, 100, 255 ), TEXT_ALIGN_CENTER )
	end )

	function ENT:Initialize()
        self:DrawShadow( false )
	end
end

--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Bag"
ENT.Category = "dHeists"

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.DHeists = true

--[[
    MONOLITH RP INVENTORY VARIABLES
]]
ENT.IsItem = true
ENT.OwnerOnlyPickUp = false
ENT.WalkOnlyPickUp = true

ENT.physicsBox = {
    mins = Vector( -7, -20, -5 ),
    maxs = Vector( 7, 10, 6 )
}

--[[ dHeists configuration ]]
ENT.BagModel = "models/jessev92/payday2/item_Bag_loot.mdl"
ENT.BagPos = dHeists.config.alternateBagPos and Vector( -7, -5, 0 ) or Vector( 0, 0, 10 )
ENT.BagAng = dHeists.config.alternateBagPos and Angle( 90, 0, 110 ) or Angle( 80, 100, 20 )
ENT.BagScale = dHeists.config.alternateBagPos and 0.8 or 1

ENT.BagCapacity = 2
ENT.BagSkin = 0

-- DarkRP/MonolithRP
ENT.BagLevel = 1
ENT.BagPrice = 5000

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 2, "LootCount" )
    self:NetworkVar( "Int", 4, "Capacity" )
    self:NetworkVar( "Entity", 0, "EntityOwner" )
end

function ENT:Initialize()
    self:PhysicsInitBox( self.physicsBox.mins, self.physicsBox.maxs )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )

	if SERVER then
        self:SetModel( self.BagModel )

        self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
        self:GetPhysicsObject():Wake()

        self:SetSkin( self.BagSkin )
		self:SetCapacity( self.BagCapacity )
        self:SetTrigger( true )

        self.lootItems = {}
	end

    self.InventoryItemID = self:GetClass()
    self:DrawShadow( false )
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

    function ENT:getLoot()
        return self.lootItems
    end

    function ENT:addLoot( lootName )
        if #self:getLoot() >= self:GetCapacity() then print("no") return false end

        table.insert( self.lootItems, lootName )

        self:SetLootCount( self:GetLootCount() + 1 )

        return true
    end

    function ENT:setLoot( lootTable )
        self.lootItems = lootTable
        self:SetLootCount( table.Count( lootTable ) )

        return true
    end

    function ENT:playActionSound()
        self:EmitSound( "npc/combine_soldier/gear" .. math.random( 1, 3 ) .. ".wav" )
    end

    function ENT:doPickUpAction( player )
        if player:getBag() then player:dHeistsNotify( dL "already_have_bag", NOTIFY_ERROR ) return end

        local entityOwner = self:GetEntityOwner()
        local playerIsOwner = entityOwner == player

        local canDo, reason = hook.Run( "dHeists.bagPickUp", player, self )
        if canDo == false then
            if reason then player:dHeistsNotify( reason, NOTIFY_GENERIC ) end

            return
        end

        dHeists.actions.doAction( player, playerIsOwner and dHeists.config.bagPickUpTime or dHeists.config.stealPickUpBagTime, function()
            if not IsValid( self ) then return end
            if player:getBag() then return end

            player:setBag( self )

            self:playActionSound()

            self.IsTaken = true

            SafeRemoveEntity( self )
        end, {
            ent = self,
            ActionColor = playerIsOwner and dHeists.config.pickUpBagActionColor or dHeists.config.stealPickUpBagActionColor,
            ActionTimeRemainingTextPhrase = playerIsOwner and "picking_up_bag" or "stealing_bag"
        } )
    end

    function ENT:doEffect()
        local effectData = EffectData()
        effectData:SetOrigin( self:GetPos() )
        effectData:SetScale( 10 )
        util.Effect( "inflator_magic", effectData )

        self:playActionSound()
    end

    function ENT:doConfiscateAction( player )
        dHeists.actions.doAction( player, dHeists.config.bagConfiscateTime, function()
            if not IsValid( self ) or self.IsTaken then return end

            SafeRemoveEntity( self )

            self.IsTaken = true

            local moneyGiven = dHeists.config.confiscateBagMoneyPrize
            dHeists.addMoney( player, moneyGiven )

            player:dHeistsNotify( dL( "confiscate_bag_text", string.formatMoney( moneyGiven ) ), NOTIFY_GENERIC )
        end, {
            ent = self,
            ActionColor = dHeists.config.confiscateBagActionColor,
            ActionTimeRemainingTextPhrase = dL( "confiscating_bag" )
        } )
    end

    function ENT:Use( player )
        if player:KeyDown( IN_WALK ) then return end

        local shouldConfiscate = dHeists.gamemodes:isPolice( player )

        if shouldConfiscate then
            self:doConfiscateAction( player )
        else
            self:doPickUpAction( player )
        end
    end
end

if CLIENT then

    local hudX, hudY = 50, 0
    local hudWidth, hudHeight = 180, 50
    function ENT:Draw()
    	self:DrawModel()

        if dHeists.config.debugEnabled then
            render.DrawWireframeBox( self:GetPos(), self:GetAngles(), self.physicsBox.mins, self.physicsBox.maxs, color_white )
        end

        -- 3D
        self.camPos = self:GetPos() + self:GetUp() * 7 + self:GetForward() * -3 + self:GetRight() * 20
        self.camAng = self:GetAngles()
        self.camAng:RotateAroundAxis( self.camAng:Right(), -90 )
        self.camAng:RotateAroundAxis( self.camAng:Up(), 90 )
        self.camAng:RotateAroundAxis( self.camAng:Forward(), 270 )

        local loot = self.GetLootCount and self:GetLootCount() or 0
        local capacity = self.GetCapacity and self:GetCapacity() or 4
        local fraction = loot / capacity

        cam.Start3D2D( self.camPos, self.camAng, .1 )
            draw.RoundedBox( 0, hudX, hudY, hudWidth * fraction, hudHeight, Color( 0, 151, 0, 100 ) )

            surface.DrawCuteRect( hudX, hudY, hudWidth, hudHeight, 3 )

            draw.SimpleText( loot .. "/" .. capacity, "dHeists_bagText3D", hudX + ( hudWidth / 2 ), hudY + ( hudHeight / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        cam.End3D2D()
    end
end

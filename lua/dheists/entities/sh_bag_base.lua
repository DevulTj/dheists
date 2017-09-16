--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ENT = {}

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Bag"
ENT.Category = "dHeists"

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsBag = true

ENT.physicsBox = {
    mins = Vector( -7, -20, -5 ),
    maxs = Vector( 7, 10, 6 )
}

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "BagType" )
    self:NetworkVar( "Int", 2, "LootCount" )
    self:NetworkVar( "Int", 4, "Capacity" )
    self:NetworkVar( "Entity", 0, "EntityOwner" )
end

if SERVER then
    function ENT:Initialize()
        local selectedModel = dHeists.config.bagModel
        local isValidModel = file.Exists( selectedModel, "GAME" )

        if not isValidModel then
            selectedModel = "models/jessev92/payday2/item_Bag_loot.mdl"
        end

        self:SetModel( selectedModel )

        self:PhysicsInitBox( self.physicsBox.mins, self.physicsBox.maxs )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )

        self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
        self:GetPhysicsObject():Wake()

        local randomBagData = table.Random( dHeists.bags.list )
        if not randomBagData then
            SafeRemoveEntity( self )

            return
        end

        self:setBagType( randomBagData.name )

        self.lootItems = {}
    end

    function ENT:getLoot()
        return self.lootItems
    end

    function ENT:addLoot( lootName )
        if #self:getLoot() >= self:GetCapacity() then return false end

        table.insert( self.lootItems, lootName )

        self:SetLootCount( self:GetLootCount() + 1 )

        return true
    end

    function ENT:setLoot( lootTable )
        self.lootItems = lootTable
        self:SetLootCount( table.Count( lootTable ) )

        return true
    end

    function ENT:setBagType( bagType )
        local bagInfo = dHeists.bags.getBag( bagType )
        if not bagInfo then
            SafeRemoveEntity( self )

            return
        end

        self:SetBagType( bagInfo.bagType ) -- Bag types
        if bagInfo.skin then self:SetSkin( bagInfo.skin ) end

        self:SetCapacity( bagInfo.capacity or dHeists.config.defaultBagCapacity or 4 )
    end

    function ENT:playActionSound()
        self:EmitSound( "npc/combine_soldier/gear" .. math.random( 1, 3 ) .. ".wav" )
    end

    function ENT:doPickUpAction( player )
        local entityOwner = self:GetEntityOwner()
        local playerIsOwner = entityOwner == player

        dHeists.actions.doAction( player, playerIsOwner and dHeists.config.bagPickUpTime or dHeists.config.stealPickUpBagTime, function()
            if player:getBag() then return end

            player:setBag( self )

            self:playActionSound()

            SafeRemoveEntity( self )
        end, {
            ent = self,
            ActionColor = playerIsOwner and dHeists.config.pickUpBagActionColor or dHeists.config.stealPickUpBagActionColor,
            ActionTimeRemainingText = playerIsOwner and dHeists.config.pickUpBagActionText
                or dHeists.config.stealPickUpBagActionText .. ( IsValid( entityOwner ) and ( " FROM " .. entityOwner:Nick():upper() ) or "" )
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
            SafeRemoveEntity( self )

            local moneyGiven = dHeists.config.confiscateBagMoneyPrize
            dHeists.addMoney( player, moneyGiven )
            dHeists.addNotification( player, ( dHeists.config.confiscateBagText or "You were given %s" ):format( dHeists.formatMoney( moneyGiven ) ) )
        end, {
            ent = self,
            ActionColor = dHeists.config.confiscateBagActionColor,
            ActionTimeRemainingText = dHeists.config.confiscateBagActionText
        } )
    end

    function ENT:Use( player )
        local shouldConfiscate = dHeists.isPolice( player )

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

	function ENT:Initialize()
        self:DrawShadow( false )
	end
end

properties.Add( "setbagtype", {
	MenuLabel = "Set Bag Type",
	Order = 0,
	MenuIcon = "icon16/briefcase.png",

	Filter = function( self, ent, ply )
		if not ent.IsBag then return false end
		if not gamemode.Call( "CanProperty", ply, "setbagtype", ent ) then return false end

		return true
	end,
	Action = function( self, ent ) -- CLIENT
        Derma_StringRequest(
            "Set Bag Type",
            "Input a number with the bag type",
            "",
            function( text )
                if not tonumber( text ) then return end

                self:MsgStart()
                    net.WriteEntity( ent )
                    net.WriteUInt( text, 8 )
                self:MsgEnd()
            end,
            function( text ) end
        )

	end,
	Receive = function( self, length, player ) -- SERVER
		local ent = net.ReadEntity()
		if not self:Filter( ent, player ) then return end

		ent:setBagType( net.ReadUInt( 8 ) )
	end
} )

scripted_ents.Register( ENT, "dheists_bag_base" )

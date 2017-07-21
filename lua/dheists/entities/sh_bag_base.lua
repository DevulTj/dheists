--[[
	© 2017 devultj.co, do not share, re-distribute or modify

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

if SERVER then
    function ENT:SetupDataTables()
        self:NetworkVar( "Int", 0, "BagType" )
        self:NetworkVar( "Entity", 0, "EntityOwner" )
    end

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

        --self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
        self:GetPhysicsObject():Wake()

        self:setBagType( 0 )
    end

    function ENT:setBagType( bagType )
        if not tonumber( bagType ) then return end

        print("setting bag type", bagType)

        self:SetBagType( bagType ) -- Bag types
        self:SetSkin( bagType )
    end

    function ENT:playActionSound()
        self:EmitSound( "npc/combine_soldier/gear" .. math.random( 1, 3 ) .. ".wav" )
    end

    function ENT:doPickUpAction( player )
        local entityOwner = self:GetEntityOwner()
        local playerIsOwner = entityOwner == player

        dHeists.actions.doAction( player, playerIsOwner and dHeists.config.bagPickUpTime or dHeists.config.stealPickUpBagTime, function()
            if player._dHeistsBag then return end

            player._dHeistsBag = {
                bagType = self:GetBagType()
            }

            self:playActionSound()

            SafeRemoveEntity( self )
            renderObjects:setObject( player, "bag_" .. self:GetBagType() )
            player:SetNW2Bool( "dHeists_CarryingBag", true )
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
            self:doEffect()

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
    function ENT:Draw()
    	self:DrawModel()

        if dHeists.config.debugEnabled then
            render.DrawWireframeBox( self:GetPos(), self:GetAngles(), self.physicsBox.mins, self.physicsBox.maxs, color_white )
        end
    end

	function ENT:Initialize()
        self:DrawShadow( false )
	end
end

scripted_ents.Register( ENT, "dheists_bag_base" )

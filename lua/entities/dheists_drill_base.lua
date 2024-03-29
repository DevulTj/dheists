--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Drill Base"

ENT.Spawnable = false
ENT.AdminSpawnable	= true
ENT.DHeists = true

ENT.physicsBox = {
    mins = Vector( -7, -20, -5 ),
    maxs = Vector( 7, 10, 6 )
}

sound.Add {
    name = "dHeists.drillSound",
    channel = CHAN_STATIC,
    volume = 0.75,
    level = SNDLVL_65dB,
    pitch = 120,

    sound = "vehicles/digger_grinder_loop1.wav"
}

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", 0, "IsDrilling" )
    self:NetworkVar( "Float", 0, "DrillStart" )
    self:NetworkVar( "Float", 1, "DrillEnd" )
    self:NetworkVar( "Entity", 1, "LastPickedUp" )
end

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

    self:PhysicsInitBox( self.physicsBox.mins, self.physicsBox.maxs )
    self:Activate()

    self:SetAutomaticFrameAdvance( false )

    self:SetSkin( self.DrillSkin or 0 )
    self:SetModelScale( self.DrillScale or 1 )
end

function ENT:getPercent()
    return math.TimeFraction( self:GetDrillStart(), self:GetDrillEnd(), CurTime() )
end

function ENT:isFinished()
    return self:getPercent() >= 1
end

ENT.DrillStates = {
    [ "Active" ] = 1,
    [ "Finished" ] = 2,
    [ "Error" ] = 3,
    [ "NotSetup" ] = 4
}

function ENT:getDrillState()
    if self:getPercent() < 1 and self:getPercent() > 0 then
        return self.DrillStates.Active
    elseif not IsValid( self:GetParent() ) then
        return self.DrillStates.NotSetup
    elseif self:getPercent() >= 1 then
        return self.DrillStates.Finished
    end

    return self.DrillStates.Error
end

function ENT:doDestroyAction( player )
    dHeists.actions.doAction( player, dHeists.config.drillDestroyTime or 5, function()
        if not IsValid( self ) or self.IsTaken then return end

        SafeRemoveEntity( self )

        if IsValid( self:GetParent() ) then
            self:GetParent():StopSound( "dHeists.drillSound" )
        end

        self.IsTaken = true

        if dHeists.config.drillDestroyRewardEnabled then
            local moneyGiven = dHeists.config.drillDestroyMoneyPrize or 500
            dHeists.addMoney( player, moneyGiven )
        end

        player:dHeistsNotify( dL( "drill_destroyed_text", string.formatMoney( moneyGiven ) ), NOTIFY_GENERIC )
    end, {
        ent = self,
        ActionColor = dHeists.config.drillDestroyActionColor,
        ActionTimeRemainingTextPhrase = dL( "destroying_drill" )
    } )
end

function ENT:Use( player )
    if player:KeyDown( IN_WALK ) then return end

    local shouldDestroy = dHeists.gamemodes:isPolice( player )

    if shouldDestroy then
        self:doDestroyAction( player )
    end
end

function ENT:StartTouch( eEnt )
    if not IsEntity( eEnt ) then return end

    if eEnt.IsRobbableEntity and eEnt.setDrill then
        eEnt:setDrill( self )

        self:SetIsDrilling( true )
    end
end

if CLIENT then
    ENT.PanelInfo = {
        pos = Vector( -8.5, 8.2, 2.2 ),

        w = 72,
        h = 60
    }

    ENT.DrillStateNames = {
        "DRILLING",
        "FINISHED",
        "ERROR",
        "PLACE ME"
    }

    ENT.DrillColors = {
        Color( 0, 150, 0 ),
        Color( 255, 150, 0 ),
        Color( 150, 0, 0 ),
        Color( 150, 150, 150 ),
    }

    function ENT:Draw()
    	self:DrawModel()

        local drillState = self:getDrillState()

        local fFraction = math.Clamp( math.TimeFraction( self:GetDrillStart(), self:GetDrillEnd(), CurTime() ), 0, 1 )
        local sActive = not IsValid( self:GetParent() ) and "?" or math.Clamp( math.ceil( self:GetDrillEnd() - CurTime() ), 0, 5000 ) .. " sec"
        local sPercentage = self.DrillStateNames[ drillState ] or ""

        local drillStateColor = self.DrillColors[ drillState ]

        local nModelScale = self:GetModelScale()
        local vPos = self:GetPos() + ( ( self:GetUp() * 2 + self:GetRight() * - 9.7 + self:GetForward() * 6.6 ) * nModelScale )
        local aAng = self:GetAngles()
        aAng:RotateAroundAxis( aAng:Right(), 60 )
        aAng:RotateAroundAxis( aAng:Up(), -90 )
        aAng:RotateAroundAxis( aAng:Forward(), 0 )

        cam.Start3D2D( vPos, aAng, 0.1 * nModelScale )
            draw.RoundedBox( 0, 0, 0, self.PanelInfo.w, self.PanelInfo.h, Color( 255, 255, 255 ) )
            draw.RoundedBox( 0, 2, 2, self.PanelInfo.w - 4, self.PanelInfo.h - 4, Color( 50, 50, 50 ) )
            draw.RoundedBox( 0, 2, 2, self.PanelInfo.w - 4, 6, Color( 150, 150, 150 ) )

            draw.RoundedBox( 0, 8, 36, self.PanelInfo.w - 16, 4, Color( 0, 0, 0, 150 ) )
            draw.RoundedBox( 0, 8, 36, ( self.PanelInfo.w - 16 ) * fFraction, 4, drillStateColor )

            draw.SimpleText( sActive, "dHeistsSmall", self.PanelInfo.w / 2 + 2, self.PanelInfo.h / 2.9 + 2, Color( 0, 0, 0, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( sActive, "dHeistsSmall", self.PanelInfo.w / 2, self.PanelInfo.h / 2.9, Color( 250, 250, 250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

            draw.SimpleText( sPercentage, "dHeistsSmall", self.PanelInfo.w / 2 + 2, self.PanelInfo.h / 1.3 + 2, Color( 0, 0, 0, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( sPercentage, "dHeistsSmall", self.PanelInfo.w / 2, self.PanelInfo.h / 1.3, drillStateColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        cam.End3D2D()
    end

	function ENT:Initialize()
        self:DrawShadow( false )
	end
end

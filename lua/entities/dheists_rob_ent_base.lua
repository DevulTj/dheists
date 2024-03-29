--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Robbable Entity"
ENT.Category = "dHeists"
ENT.AutomaticFrameAdvance = false

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsRobbableEntity = true
ENT.DHeists = true

-- Used for saving
ENT._Entity = "objects"

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "ZoneID" )
    self:NetworkVar( "String", 0, "EntityType" )
    self:NetworkVar( "Entity", 0, "Drill" )

    self:NetworkVar( "Int", 1, "CooldownStart" )
    self:NetworkVar( "Int", 1, "CooldownEnd" )
end

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )
		if not tr.Hit then return end

		local SpawnPos = tr.HitPos + tr.HitNormal * 1

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

        local randomEntData = table.Random( dHeists.robbing.list )
        if not randomEntData then
            SafeRemoveEntity( self )

            return
        end

        self:setEntityType( randomEntData )
    end

    function ENT:getZone()
        return self.zone
    end

    function ENT:setZone( zone )
        self.zone = zone

        self:SetZoneID( zone:getId() )
    end

    function ENT:setEntityType( entType )
        local entData = istable( entType ) and entType or dHeists.robbing.getEnt( entType )
        if not entData then return end

        self.typeInfo = entData

        self:SetEntityType( entData.name )
        self:SetModel( entData.model )

        if entData.material then self:SetMaterial( entData.material ) end

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )

        self:GetPhysicsObject():EnableMotion( false )

        if entData.lootSpawnPoint then
            self.lootSpawnPoint = entData.lootSpawnPoint
        end

        self:SetMaterial( "" )

        self.lootItems = entData.loot

        if entData.onSpawn then
            entData.onSpawn( self )
        end
    end

    function ENT:spawnLoot()
        local lootItems = self.lootItems
        local randomItem = lootItems[ math.random( 1, #lootItems ) ]

        if istable( randomItem ) and randomItem.class then
            local entity = ents.Create( randomItem.class )
            entity:SetPos( self:LocalToWorld( self.lootSpawnPoint or Vector( 0, 0, 0 ) ) )

            entity:Spawn()
            entity:Activate()

            if randomItem.callback then randomItem.callback( self, entity ) end
        else
            local lootData = dHeists.loot.getLoot( randomItem )
            if not lootData then return end

            local entity = ents.Create( "dheists_loot_base" )
            entity:SetPos( self:LocalToWorld( self.lootSpawnPoint or Vector( 0, 0, 0 ) ) )

            entity:Spawn()
            entity:Activate()

            entity:setLootType( randomItem )
        end
    end

    function ENT:deployLoot()
        print("running deployLoot")
        local data = self.typeInfo
        if data then
            if data.onFinish then
                data.onFinish( self, data )
            end

            if data.openSequence then
                -- Run the open sequence
                local sequenceId = self:LookupSequence( data.openSequence )
                self:ResetSequence( sequenceId )

                -- Delay spawning & animation reset until the open animation has finished
                timer.Simple( self:SequenceDuration( sequenceId ), function()
                    if not IsValid( self ) then return end

                    -- Manually spawn loot
                    if not data.customLootSpawn then
                        self:spawnLoot()
                    end

                    timer.Simple( data.cooldown or 60, function()
                        if not IsValid( self ) then return end

                        self:ResetSequence( self:LookupSequence( data.closeSequence or "idle" ) )
                    end )
                end )
            else
                if not data.customLootSpawn then
                    self:spawnLoot()
                end
            end
        end
    end

    function ENT:getCooldown()
        return self.cooldown
    end

    function ENT:isOnCooldown()
        return self:getCooldown() and self:getCooldown() > CurTime() and true or false
    end

    function ENT:setCooldown( amount )
        self.cooldown = CurTime() + ( amount or 60 )

        self:SetCooldownStart( CurTime() )
        self:SetCooldownEnd( self.cooldown )
    end

    function ENT:canDeploy( player )
        if self:isOnCooldown() then
            player:dHeistsNotify( dL "cooldown_active", NOTIFY_ERROR )

            return
        end

        if IsValid( self:GetDrill() ) then
            local drill = self:GetDrill()
            if drill:isFinished() then
                return true
            else
                player:dHeistsHint( dL "drill_active", NOTIFY_ERROR )

                return false
            end
        end

        local toolList = ""
        if self.typeInfo.canLockpick then
            toolList = toolList .. " Lockpick,"
        end

        if self.typeInfo.canDrill then
            toolList = toolList .. " Drill,"
        end

        toolList = toolList:sub( 1, #toolList - 1 )

        player:dHeistsHint( dL( "required_tools", toolList ), NOTIFY_HINT )

        return false
    end

    function ENT:trigger()
        self:getZone():startAlarm()
    end

    function ENT:canRob()
        if self.GetDrill and IsValid( self:GetDrill() ) then return false, dL "drill_active" end -- Disallow more than one drill on an entity at once.
        if self:isOnCooldown() then return false, dL "cooldown_active" end

        if self:getZone() and not self:getZone():isRequiredPoliceCount() then return false, dL "not_enough_cops" end

        return true
    end

    hook.Add( "GravGunOnPickedUp", "dHeists.Drills", function( player, entity )
        if entity.DHeists and entity.IsDrill then
            entity:SetLastPickedUp( player )
        end
    end )

    hook.Add( "GravGunOnDropped", "dHeists.Drills", function( player, entity )
        if entity.DHeists and entity.IsDrill then
            entity:SetLastPickedUp( nil )
        end
    end )

    function ENT:setDrill( drillEnt )
        if not self.GetEntityType then return end
        if self.CanNextInteract and self.CanNextInteract > CurTime() then return end

        self.CanNextInteract = CurTime() + 1

        local canDo, reason = self:canRob()
        if canDo == false then
            if reason then
                if IsValid( drillEnt:GetLastPickedUp() ) then
                    drillEnt:GetLastPickedUp():dHeistsHint( reason, NOTIFY_ERROR )
                else
                    dHeists.print( reason )
                end
            end
            return
        end

        local typeInfo = dHeists.robbing.getEnt( self:GetEntityType() )
        if not typeInfo then return end

        if not typeInfo.canDrill then return end

        self.typeInfo = typeInfo

        drillEnt:SetParent( self )
        drillEnt:SetPos( typeInfo.drillPos )

        local localAng = self:LocalToWorldAngles( typeInfo.drillAng or Angle( 0, 0, 0 ) )
        drillEnt:SetAngles( localAng )

        drillEnt:SetDrillStart( CurTime() )
        drillEnt:SetDrillEnd( CurTime() + ( ( typeInfo.drillTime or 60 ) * ( drillEnt.DrillTimeNormal or 1 ) ) )

        self:SetDrill( drillEnt )

        -- Trigger a robbery, alarms
        self:trigger()

        self:EmitSound( "dHeists.drillSound" )
    end

    function ENT:removeDrill()
        if IsValid( self:GetDrill() ) then
            SafeRemoveEntity( self:GetDrill() )
        end

        self:StopSound( "dHeists.drillSound" )
    end

    function ENT:deploy()
        self:deployLoot()

        if self:GetDrill() then
            self:removeDrill()
        end

        local typeInfo = dHeists.robbing.getEnt( self:GetEntityType() )
        if not typeInfo then return end

        self:setCooldown( typeInfo.cooldown or 60 )
    end

    function ENT:Use( activator, player )
        if not self:canDeploy( player ) then return end

        self:deploy()
    end
end

if CLIENT then
    function ENT:Draw()
    	self:DrawModel()

        local typeInfo = dHeists.robbing.getEnt( self:GetEntityType() )
        if not typeInfo then return end

        local lootSpawnPos = typeInfo.textPos or typeInfo.lootSpawnPoint

        if dHeists.config.debugEnabled then

            local entPos = self:GetPos()

            if lootSpawnPos then
                render.DrawLine( entPos, self:LocalToWorld( lootSpawnPos ), color_white )
                render.SetColorMaterial()
                render.DrawSphere( self:LocalToWorld( lootSpawnPos ), 10, 30, 30, Color( 255, 255, 255, 100 ) )
            end

            local drillPos = typeInfo.drillPos
            if drillPos then
                local drillVector = self:LocalToWorld( drillPos )
                    drillVector.z = drillVector.z + 1
                local direction = Vector( entPos.x - drillVector.x, entPos.y - drillVector.y, entPos.z - drillVector.z + 1 )

                render.DrawLine( drillVector, drillVector + direction, Color( 250, 50, 50, 150 ) )
                render.SetColorMaterial()
                render.DrawSphere( drillVector, 5, 30, 30, Color( 250, 50, 50, 150 ) )
            end
        end

        if lootSpawnPos then
            local cooldownStart = self:GetCooldownStart()
            local cooldownEnd = self:GetCooldownEnd()

            if cooldownStart <= 0 or cooldownEnd <= 0 then return end
            if cooldownEnd < CurTime() then return end

            -- 3D
            self.camPos = self:LocalToWorld( lootSpawnPos )
            self.camAng = self:GetAngles()
            self.camAng:RotateAroundAxis( self.camAng:Right(), 0 )
            self.camAng:RotateAroundAxis( self.camAng:Up(), 90 )
            self.camAng:RotateAroundAxis( self.camAng:Forward(), 90 )

            if typeInfo.textAng then
                self.camAng = self.camAng + typeInfo.textAng
            end

            local width, height = 256, 186
            local xPos, yPos = -( width / 2 ), -( height / 2 )
            cam.Start3D2D( self.camPos, self.camAng, .1 )
                surface.DrawCuteRect( xPos, yPos, width, height, 3 )

                local remainingTime = string.FormattedTime( math.max( cooldownEnd - CurTime(), 0 ), "%02i:%02i:%02i" )
                draw.SimpleText( dL( "cooldown_3d" ), "dHeistsHuge", 0, - 48, Color( 255, 50, 50 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                draw.SimpleText( remainingTime, "dHeistsMassive", 0, 24, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            cam.End3D2D()
        end
    end

	function ENT:Initialize()
        self:DrawShadow( false )
	end
end

properties.Add( "setrobenttype", {
	MenuLabel = "Set Entity Type",
	Order = 0,
	MenuIcon = "icon16/briefcase.png",

	Filter = function( self, ent, ply )
		if not ent.IsRobbableEntity then return false end
		if not gamemode.Call( "CanProperty", ply, "setrobenttype", ent ) then return false end

		return true
	end,
    Action = function( self, ent ) -- CLIENT
        Derma_ComboRequest(
            "Set Entity Type",
            "Select which Robbable Entity you would like to use.",
            dHeists.robbing:getEntNames(),
            "Submit",
            function( button, value, data )
                if not tostring( value ) then return end

                self:MsgStart()
                    net.WriteEntity( ent )
                    net.WriteString( value )
                self:MsgEnd()
            end
        )

	end,
	Receive = function( self, length, player ) -- SERVER
		local ent = net.ReadEntity()
		if not self:Filter( ent, player ) then return end

		ent:setEntityType( net.ReadString() )
	end
} )

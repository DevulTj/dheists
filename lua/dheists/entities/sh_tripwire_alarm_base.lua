--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ENT = {}

ENT.Base                    = "base_anim"
ENT.Type                    = "anim"

ENT.Author                  = "Flixs"

ENT.PrintName               = "Tripwire Alarm"
ENT.Category                = "dHeists"

ENT.Spawnable               = true
ENT.AdminOnly               = true

ENT.AutomaticFrameAdvance   = true

ENT.MODEL                   = "models/xqm/button1.mdl"

ENT._nextThink              = .1

ENT._isAlarmOn              = false

local VECTOR_MIN_MAX    = Vector( 2, 2, 2 )
ENT._traceMins          = VECTOR_MIN_MAX
ENT._traceMaxs          = VECTOR_MIN_MAX * -1
ENT._traceStartOffset   = 3
ENT._traceEndOffset     = 250

ENT._heistZone = nil

ENT._child = nil

function ENT:Initialize()
    if SERVER then
        self:SetModel( self.MODEL )
        self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )

        local ent = ents.Create( "dheists_entity_trigger" )
        ent:SetAngles( Angle( 0, 0, 0 ) )
        local pos = self:GetPos() + self:GetUp() * 125
        local trace = util.TraceLine( {
            start = pos,
            endpos = pos + ( -ent:GetUp() * 100 ),
            filter = ent
        } )
        ent:SetPos( trace.HitPos + Vector( 0, 0, -1 ) )
        ent:Spawn()
        ent:Activate()

        ent:SetParent( self )
        self:SetChild( ent )
        self:CallOnRemove( "RemoveChild", function( child )
            SafeRemoveEntity( child )
        end )
    else
        self:DrawShadow( false )
    end
end

if SERVER then
    function ENT:SetChild( ent )
        self._child = ent
    end

    function ENT:GetChild()
        return self._child
    end

    function ENT:SetIsAlarmOn( isAlarmOn )
        self._isAlarmOn = isAlarmOn
    end

    function ENT:GetIsAlarmOn()
        return self._isAlarmOn
    end

    function ENT:SetHeistZone( heistZone )
        self._heistZone = heistZone
    end

    function ENT:GetHeistZone()
        return self._heistZone
    end

--[[--------For Compatibility--------]]--
    function ENT:getZone()
        return self:GetHeistZone()
    end

    function ENT:setZone( zone )
        self:SetHeistZone( zone )
    end
--[[---------------------------------]]--

    function ENT:ActivateAlarm()
        if self:GetIsAlarmOn() then return end
        self:SetIsAlarmOn( true )

        local heistZone = self:GetHeistZone()
        if not heistZone then return end
        heistZone:startAlarm()
    end

    function ENT:deActivate()
        if not self:GetIsAlarmOn() then return end
        self:SetIsAlarmOn( false )
    end

    -- Checks if the player who triggered is an valid target, for cops example
    -- shoudln't trigger the tripwire alarm
    function ENT:IsValidTarget( ply )
        if not IsValid( ply ) then return false end

        local triggersAlarm = hook.Run( "dHeists.TriggersTripwire", ply, self )
        if triggersAlarm == true then
            return true
        else
            return false
        end
    end

    function ENT:TriggerAlarm( ply )
        if self:GetIsAlarmOn() then return end

        if IsValid( ply ) and ply:IsPlayer() and self:IsValidTarget( ply ) then
            self:ActivateAlarm()
        end
    end

    hook.Add( "dHeists.TriggersTripwire", "dHeists.TriggersTripwire", function( player, tripwire )
        local jobCategory = dHeists.gamemodes:getJobCategory( player )
        if not jobCategory then return end

        local zone = tripwire:getZone()
        if not zone then return end

        if not zone.jobCategories or not zone.jobCategories[ jobCategory ] then return true end
    end )
else
    function ENT:Draw()
        self:DrawModel()
    end
end

scripted_ents.Register( ENT, "dheists_tripwire_alarm_base" )

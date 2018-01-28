--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ENT = {}

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Alarm"
ENT.Category = "dHeists"
ENT.AutomaticFrameAdvance = true

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsAlarm = true

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", 0, "AlarmActive" )
end

if SERVER then
    function ENT:Initialize()
        -- assign a default model, with physics etc.
        self:SetModel( "models/props/de_nuke/emergency_lighta.mdl" )

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:GetPhysicsObject():Wake()
    end

    function ENT:getZone()
        return zone
    end

    function ENT:setZone( zone )
        self.zone = zone
    end

    function ENT:activate()
        if self:GetAlarmActive() then return end

        self:SetAlarmActive( true )

        self:EmitSound( dHeists.alarms.alarmSound )

        timer.Simple( 30, function() 
            if IsValid( self ) then
                self:deActivate()
            end
        end )
    end

    function ENT:deActivate()
        self:SetAlarmActive( false )
        self:StopSound( dHeists.alarms.alarmSound )
    end

    function ENT:Use()
        self:activate()
    end

    function ENT:OnRemove()
        self:StopSound( dHeists.alarms.alarmSound )
    end
end

if CLIENT then
    function ENT:Draw()
    	self:DrawModel()
     
        if self:GetAlarmActive() then
            -- Sine wave, one peak a second
            local brightnessValue = ( math.cos( CurTime() * 1.5 * math.pi ) + 1 ) / 2 
            local dynamicLight = DynamicLight( self:EntIndex() )
            if dynamicLight then
                dynamicLight.pos = self:GetPos()
                dynamicLight.r = 255
                dynamicLight.g = 0
                dynamicLight.b = 0
                dynamicLight.brightness = 1
                dynamicLight.Decay = 1000
                dynamicLight.Size = brightnessValue * 256
                dynamicLight.DieTime = CurTime() + 1
            end
        end
    end

	function ENT:Initialize()
        self:DrawShadow( false )
	end
end

scripted_ents.Register( ENT, "dheists_alarm_base" )

--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Alarm"
ENT.Category = "dHeists"
ENT.AutomaticFrameAdvance = false

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsAlarm = true

ENT.DHeists = true

-- Used for saving
ENT._Entity = "alarms"

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", 0, "AlarmActive" )
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
        self:SetModel( "models/props/de_nuke/emergency_lighta.mdl" )

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:GetPhysicsObject():Wake()

        self:setAlarmSound( "Firebell Alarm", "ambient/alarms/city_firebell_loop1.wav" )
    end

    function ENT:getZone()
        return self.zone
    end

    function ENT:setZone( zone )
        self.zone = zone
    end

    function ENT:activate()
        if self:GetAlarmActive() then return end

        self:SetAlarmActive( true )

        self:EmitSound( self.alarmSound )

        timer.Simple( self.alarmDuration or 30, function()
            if IsValid( self ) then
                self:deActivate()
            end
        end )
    end

    function ENT:deActivate()
        self:SetAlarmActive( false )
        self:StopSound( self.alarmSound )

        local zone = self:getZone()
        if not zone then return end
        zone:stopAlarm()
    end

    function ENT:OnRemove()
        self:StopSound( self.alarmSound )
    end

    function ENT:setAlarmSound( name, path, data )
        self.alarmSound = name

        sound.Add {
            name = name,
            channel = data and data.channel or CHAN_STATIC,
            volume = data and data.volume or 1,
            level = data and data.level or SNDLVL_100dB,
            pitch = data and data.pitch or 100,

            sound = data and data.sound or path
        }
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

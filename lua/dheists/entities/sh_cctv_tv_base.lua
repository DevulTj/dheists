--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ENT = {}

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "CCTV Controller"
ENT.Category = "dHeists"
ENT.AutomaticFrameAdvance = true

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsAlarm = true

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "ZoneID" )
end

if SERVER then
    function ENT:Initialize()
        -- assign a default model, with physics etc.
        self:SetModel( "models/props_lab/monitor02.mdl" )

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )

        self:GetPhysicsObject():Wake()
    end

    function ENT:getZone()
        return self.zone
    end

    function ENT:setZone( zone )
        self.zone = zone

        self:SetZoneID( zone:getId() )
    end

    function ENT:Use( player )
        if not self:getZone() then dHeists.gamemodes:notify( player, i18n.getPhrase( "no_zone" ), NOTIFY_ERROR ) return end
        
        dHeists.cctv.viewCCTV( player, self )
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

scripted_ents.Register( ENT, "dheists_cctv_tv_base" )

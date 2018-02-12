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
ENT.AutomaticFrameAdvance = false

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsAlarm = true

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "ZoneID" )
    self:NetworkVar( "String", 0, "ZoneName" )
end

if SERVER then
    function ENT:Initialize()
        -- assign a default model, with physics etc.
        self:SetModel( "models/testmodels/apple_display.mdl" )

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )

        self:GetPhysicsObject():Wake()

        self:SetAutomaticFrameAdvance( false )
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

        self.AngB = self:GetAngles()
        self.AngB:RotateAroundAxis(self.AngB:Right(),-90)
        self.AngB:RotateAroundAxis(self.AngB:Up(),90)
        self.AngB:RotateAroundAxis(self.AngB:Forward(),-5.7)

        cam.Start3D2D(self:GetPos() + self:GetUp()*8	+ self:GetForward()*2.35, self.AngB,0.15)
        surface.SetDrawColor(100,150,150,40)
        draw.SimpleTextOutlined(self:GetZoneName(), "dHeistsMedium",0,-32,Color(235,235,235),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0, 100))
        draw.SimpleTextOutlined("CCTV", "dHeistsHuge",0,-74,Color(235,235,235),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0, 100))
        cam.End3D2D()
    end

	function ENT:Initialize()
        self:DrawShadow( false )
	end
end

scripted_ents.Register( ENT, "dheists_cctv_tv_base" )

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
ENT.DHeists = true

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "ZoneID" )
    self:NetworkVar( "String", 0, "ZoneName" )
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
        self:SetModel( "models/props/cs_office/computer_monitor.mdl" )

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
        if not self:getZone() then player:dHeistsNotify( dL "no_zone", NOTIFY_ERROR ) return end

        dHeists.cctv.viewCCTV( player, self )
    end
end

if CLIENT then
    local gradient = Material( "vgui/gradient-u" )
    function ENT:Draw()
    	self:DrawModel()

        self.AngB = self:GetAngles()
        self.AngB:RotateAroundAxis( self.AngB:Right(), -90 )
        self.AngB:RotateAroundAxis( self.AngB:Up(), 90 )
        self.AngB:RotateAroundAxis( self.AngB:Forward(), 0 )

        cam.Start3D2D( self:GetPos() + self:GetUp() * 8 + self:GetForward() * 3.3, self.AngB, 0.15 )
            surface.SetDrawColor( 100, 150, 150, 40 )
            draw.RoundedBox( 0, -70, -112, 142, 110, Color( 50, 50, 50, 255 ) )

            surface.SetDrawColor( Color( 25, 25, 25, 200 ) )
            surface.SetMaterial( gradient )
            surface.DrawTexturedRect( -70, -112, 142, 110 )

            draw.SimpleTextOutlined( self:GetZoneName(), "dHeistsSmall", 0, -50, Color( 235, 235, 235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 100 ) )
            draw.SimpleTextOutlined( dL "cctv_title", "dHeistsHuge", 0, -100, Color( 235, 235, 235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP,1,Color(0,0,0, 100))
        cam.End3D2D()
    end

    function ENT:Initialize()
        self:DrawShadow( false )
    end
end

scripted_ents.Register( ENT, "dheists_cctv_tv_base" )

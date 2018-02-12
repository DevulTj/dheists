--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ENT = {}

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Zone Screen"
ENT.Category = "dHeists"
ENT.AutomaticFrameAdvance = false

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsZoneScreen = true

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "ZoneID" )
    self:NetworkVar( "String", 0, "ZoneName" )
    self:NetworkVar( "Int", 0, "CooldownEnd" )
end

if SERVER then
    function ENT:Initialize()
        -- assign a default model, with physics etc.
        self:SetModel("models/hunter/plates/plate05x2.mdl")
        self:SetMaterial("phoenix_storms/dome")

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )
        self:SetAutomaticFrameAdvance( false )
        
    end

    function ENT:getZone()
        return self.zone
    end

    function ENT:setZone( zone )
        self.zone = zone

        self:SetZoneID( zone:getId() )
    end
end

if CLIENT then
    surface.CreateFont( "dHeists_LCD", {
        font = "Purista",
        weight = 400,
        size = 32,
    })
    surface.CreateFont( "dHeists_LCDBig", {
        font = "Purista",
        weight = 400,
        size = 40,
    })

    local fix_rotation = Vector( 0, 90, 0 )
    local bgcolor = Color( 0, 0, 0 )

    function ENT:Draw()
        self:DrawModel()

        local isOnCooldown = self:GetCooldownEnd() and self:GetCooldownEnd() > CurTime()

        local text = isOnCooldown and "RESTOCKING" or "ACTIVE"
        local fix_angles = self:GetAngles()
        local pos = self:GetPos() + fix_angles:Up() * 1.6

        local fontcolor = isOnCooldown and Color( 255, 50, 50 ) or Color( 50, 255, 50 )

        fix_angles:RotateAroundAxis(fix_angles:Right(), fix_rotation.x)
        fix_angles:RotateAroundAxis(fix_angles:Up(), fix_rotation.y)
        fix_angles:RotateAroundAxis(fix_angles:Forward(), fix_rotation.z)

        cam.Start3D2D(pos, fix_angles, .25)
            draw.RoundedBox(0, -187, -45, 374, 90, bgcolor)

            draw.DrawText(self:GetZoneName() ~= "" and self:GetZoneName() or "Bank of Rockford", "dHeists_LCD", 0, -38, color_white, TEXT_ALIGN_CENTER)
            draw.DrawText(text, "dHeists_LCDBig", 0, -8, fontcolor, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end

	function ENT:Initialize()
        self:DrawShadow( false )
	end
end

scripted_ents.Register( ENT, "dheists_zone_screen_base" )

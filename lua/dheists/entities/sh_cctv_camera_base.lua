--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ENT = {}

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "CCTV Camera"
ENT.Category = "dHeists"
ENT.AutomaticFrameAdvance = false

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsCCTVCamera = true

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "ZoneID" )
    self:NetworkVar( "String", 0, "CameraName" )

    self:NetworkVar( "Bool", 0, "CameraDestroyed" )
end

if SERVER then
    function ENT:Initialize()
        -- assign a default model, with physics etc.
        self:SetModel( "models/props/cs_assault/camera.mdl" )

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
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

    function ENT:destroy( dDamage )
        local tEffectData = EffectData()
        tEffectData:SetOrigin( self:GetPos() )
        tEffectData:SetStart( self:GetPos() )
        util.Effect( "explosion", tEffectData )

        self:SetCameraDestroyed( true )

        local pAttacker = dDamage:GetAttacker()
        if IsValid( pAttacker ) then
            Monolith.Logger:LogEntry(
                "damage",
                Monolith.Logger:PrintPlayer( pAttacker ) .. " destroyed a CCTV camera"
            )
        end

        self:SetColor( color_black )

        timer.Simple( dHeists.config.cameraRespawnTime or 600, function()
            if IsValid( self ) then 
                self:SetColor( color_white )
                self:SetCameraDestroyed( false )
            end
        end )
    end

    hook.Add( "EntityTakeDamage", "dHeists.cameraDamage", function( eEntity, dDamage )
        if eEntity.IsCCTVCamera and not eEntity:GetCameraDestroyed() then
            local isDestroyed = eEntity:GetCameraDestroyed()
            if isDestroyed then return end

            eEntity.NextCCTVDamage = CurTime() + 0.5
            eEntity:destroy( dDamage )
        end
    end )
end

if CLIENT then
    function ENT:Draw()
    	self:DrawModel()
    end

	function ENT:Initialize()
        self:DrawShadow( false )
	end
end

scripted_ents.Register( ENT, "dheists_cctv_camera_base" )

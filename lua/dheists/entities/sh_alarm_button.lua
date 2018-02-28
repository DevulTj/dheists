--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local ENT = {}

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Alarm Button"
ENT.Category = "dHeists"
ENT.AutomaticFrameAdvance = false

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsAlarmButton = true
ENT.DHeists = true

function ENT:SetupDataTables()

end

if SERVER then
    function ENT:Initialize()
        -- assign a default model, with physics etc.
        self:SetModel( "models/maxofs2d/button_05.mdl" )

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:GetPhysicsObject():Wake()
    end

    function ENT:getZone()
        return self.zone
    end

    function ENT:setZone( zone )
        self.zone = zone
    end

	function ENT:AcceptInput( name, activator, caller )
		if name ~= "Use" or not IsValid( caller ) or not caller:IsPlayer() then return end

        if not self:getZone() then return end
        
        self:getZone():deActivateAlarms()
	end
end

if CLIENT then
    function ENT:Draw()
    	self:DrawModel()

        local drawTextDistance = 160000
        hook.Add( "HUDPaint", "dHeists.alarmButtonDraw", function()
            local entity = LocalPlayer():GetEyeTrace().Entity
            if not IsValid( entity ) or not entity.IsAlarmButton or entity:GetPos():DistToSqr( LocalPlayer():GetPos() ) > drawTextDistance then return end
            
            local pos = entity:GetPos()
            pos.z = pos.z + 10
            pos = pos:ToScreen()

            draw.SimpleText(dL( "click_to_disable_alarm" ), "dHeists_bagTextItalics", pos.x + 1, pos.y + 1, color_black, TEXT_ALIGN_CENTER )
            draw.SimpleText(dL( "click_to_disable_alarm" ), "dHeists_bagTextItalics", pos.x, pos.y, color_white, TEXT_ALIGN_CENTER )

            pos.y = pos.y + 20
        end )
    end

    function ENT:Initialize()
        self:DrawShadow( false )
    end
end

scripted_ents.Register( ENT, "dheists_alarm_button" )

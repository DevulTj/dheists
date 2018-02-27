--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
--
    > Waypoint System
    Developed by fruitwasp
]]

local _location

dHeists.waypoints = dHeists.waypoints or {}

local COMPASS_MODEL = "models/maxofs2d/lamp_flashlight.mdl"
local COMPASS_DISTANCE_DESTINATION_REACHED = 100
local DISTANCE_DIVIDER = 16

net.Receive( "dHeists.waypoints.setLocation", function()
    dHeists.waypoints.setLocation( net.ReadVector(), net.ReadString() )
end )

net.Receive( "dHeists.waypoints.clearLocation", function()
    dHeists.waypoints.setLocation( nil )
end )

function dHeists.waypoints.getLocation()
    return _location
end

function dHeists.waypoints.hasLocation()
    return glorifiedMap.getLocation() ~= nil
end

function dHeists.waypoints.setLocation( location, text )
    _location = location

    local compassModel = dHeists.compassModel

    if not location and IsValid( compassModel ) then
        compassModel:Remove()

        return
    end

    if not IsValid( compassModel ) then
        local compassX = ScrW() / 2 - 256 / 2
        local compassY = ScrH() - 16 - 128

        compassModel = vgui.Create( "DModelPanel" )
        compassModel:SetSize( 128, 128 )
        compassModel:SetPos( compassX, compassY )

        local model = util.IsValidModel( COMPASS_MODEL ) and COMPASS_MODEL
            or "models/maxofs2d/lamp_flashlight.mdl"

        compassModel:SetModel( model )
        compassModel.LayoutEntity = function() end
        compassModel:SetCamPos( Vector( 0, -30, 30 ) )
        compassModel:SetLookAt(Vector( 0, 0, 0 ))
        compassModel:SetFOV( 50 )

        compassModel.oldPaint = compassModel.Paint

        function compassModel:Paint( width, height )
            self.oldPaint( self, width, height )

            DisableClipping( true )

            self.visualUnitOfLength = "ft"

            local paintText = ( text or "" ) .. " - " .. math.ceil( ( self.distance or 0 ) / DISTANCE_DIVIDER ) .. self.visualUnitOfLength
            draw.SimpleText( paintText, "dHeistsMedium", width / 2 + 2, height - 18, Color( 0, 0, 0, 200 ), TEXT_ALIGN_CENTER )
            draw.SimpleText( paintText, "dHeistsMedium", width / 2, height - 20, color_white, TEXT_ALIGN_CENTER )

            DisableClipping( false )
        end

        function compassModel:Think()
            if not _location then
                self:Remove()

                return
            end

            local playerLocation = LocalPlayer():GetPos()

            local angles = ( _location - playerLocation ):AngleEx( Vector( 0, 1, 0 ) )
            angles = LocalPlayer():WorldToLocalAngles( angles )

            self.Entity:SetAngles( angles + Angle( 0, LocalPlayer():InVehicle() and -90 or 90, 0 ) )

            self.distance = math.ceil( playerLocation:Distance( _location ) * 0.5 )

            self.distanceMin = self.distanceMin or COMPASS_DISTANCE_DESTINATION_REACHED

            if self.distance < self.distanceMin then
                dHeists.waypoints.setLocation( nil )
            end
        end

        local frame = vgui.Create( "DFrame" )
        frame:SetTitle( "" )
        frame:SetVisible(false)
        frame.compassModel = compassModel
        frame.OnClose = function( self )
            self.compassModel:Remove()
        end
    end
end
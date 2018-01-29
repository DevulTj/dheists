--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

local FRAME = {}

function FRAME:Init()
    self:StretchToParent( 100, 100, 100, 100 )
    self:SetTitle( "CCTV" )

    self.cameraPanel = self:Add( "DPanel" )
    self.cameraPanel:Dock( LEFT )
    self.cameraPanel:SetWide( 256 )

    self.cameraLayout = self.cameraPanel:Add( "DIconLayout" )
    self.cameraLayout:Dock( FILL )

    self.cameraDisplay = self:Add( "DPanel" )
    self.cameraDisplay:Dock( FILL )
end

function FRAME:AddCamera( entity )
    local button = self.cameraLayout:Add( "DButton" )
    button:Dock( TOP )
    button:SetTall( 40 )
    button:SetText( entity:GetCameraName() )
end

function FRAME:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0 ) )
end

function FRAME:Setup( zoneId )
    local cameraList = ents.FindByClass( "dheists_cctv_camera_base" )

    for _, entity in pairs( cameraList ) do
        if entity:GetZoneID() == zoneId then
            self:AddCamera( entity )
        end
    end
end

vgui.Register( "dHeists_CCTVFrame", FRAME, "DFrame" )
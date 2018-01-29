--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

local FRAME = {}

function FRAME:Init()
    self:StretchToParent( 200, 100, 200, 100 )
    self:SetTitle( "CCTV" )
    self:MakePopup()

    self.cameraPanel = self:Add( "DPanel" )
    self.cameraPanel:Dock( LEFT )
    self.cameraPanel:DockMargin( 0, 0, 4, 0 )
    self.cameraPanel:SetWide( 256 )
    self.cameraPanel:InvalidateParent( true )

    self.cameraPanel.Paint = function( this, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
    end

    self.cameraHeader = self.cameraPanel:Add( "DButton" )
    self.cameraHeader:Dock( TOP )
    self.cameraHeader:SetTall( 30 )
    self.cameraHeader:SetText( "Camera List" )
    self.cameraHeader:SetTextColor( color_white )
    self.cameraHeader:SetFont( "dHeistsMedium" )
    self.cameraHeader:SetExpensiveShadow( 2, Color( 0, 0, 0, 100 ) )

    self.cameraHeader.Paint = function( this, w, h )
        draw.RoundedBox( 0, 1, 1, w - 2, h - 2, Color( 50, 50, 50, 255 ) )
    end

    self.cameraLayout = self.cameraPanel:Add( "DIconLayout" )
    self.cameraLayout:Dock( FILL )
    self.cameraLayout:DockMargin( 4, 4, 4, 4 )
    self.cameraLayout:SetSpaceY( 4 )
    self.cameraLayout:InvalidateParent( true )

    self.cameraDisplay = self:Add( "DPanel" )
    self.cameraDisplay:Dock( FILL )

    self.cameraDisplay.Paint = function( this, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )

        dHeists.cctv.drawCameraHUD( this, self.cameraName, self.cameraPos, self.cameraAng, w, h )
    end
end

function FRAME:SelectCamera( entity )
    self.cameraName = entity:GetCameraName()
    self.cameraPos = entity:GetPos()
    self.cameraAng = entity:GetAngles()
end

function FRAME:AddCamera( entity )
    local button = self.cameraLayout:Add( "DButton" )
    button:SetWide( self.cameraLayout:GetWide() )
    button:SetTall( 40 )
    button:SetText( entity:GetCameraName() )
    button:SetTextColor( color_white )
    button:SetFont( "dHeistsSmall" )
    button:SetExpensiveShadow( 1, Color( 0, 0, 0, 100 ) )

    button.Paint = function( this, w, h )
        local alpha = this:IsDown() and 230 or this:IsHovered() and 180 or 125
        local color = Color( 50, 50, 50, alpha )

        draw.RoundedBox( 2, 0, 0, w, h, color )
    end

    button.DoClick = function( this )
        self:SelectCamera( entity )
    end
end

function FRAME:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
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
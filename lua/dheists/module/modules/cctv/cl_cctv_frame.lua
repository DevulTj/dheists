--[[
    © 2021 Tony Ferguson, do not share, re-distribute or modify

    without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

local FRAME = {}
local suppressDraw

function FRAME:Init()
    self:StretchToParent( 200, 100, 200, 100 )
    self:SetTitle( "CCTV" )
    self:MakePopup()

    self:SetDraggable( false )

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
    self.cameraDisplay:InvalidateParent( true )

    self.cameraDisplay.Paint = function( this, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )

        if self.renderData then
            local x, y = self.renderData.origin.x, self.renderData.origin.y
            local scale = 1

            if not IsValid( self.currentCamera ) or not self.currentCamera:GetCameraDestroyed() then
                suppressDraw = true
                    render.RenderView( self.renderData )
                suppressDraw = false
            end

            local color = Color( 0, 0, 0, 100 )
            surface.SetDrawColor( color )

            surface.DrawLine( 0, h / 2, w, h / 2 )
            surface.DrawLine( w / 2, 0, w / 2, h )

            if not self.haltTimer or self.haltTimer and self.haltTimer < CurTime() then
                self.renderData.angles = Angle(
                    self.renderData.angles.p,
                    self.goingBack and self.renderData.angles.y + 0.05 or self.renderData.angles.y - 0.05,
                    self.renderData.angles.r
                )

                self.haltTimer = nil

                if not self.goingBack and math.abs( self.renderData.angles.y - self.endCameraAng.y ) <= 5 then
                    self.goingBack = true

                    self.haltTimer = CurTime() + 0.2
                end

                if self.goingBack and math.abs( self.renderData.angles.y - self.reverseCameraAng.y ) <= 5 then
                    self.goingBack = false

                    self.haltTimer = CurTime() + 0.2
                end
            end
        end

        draw.RoundedBox( 0, 0, 0, w, h, self.flickerBackgroundColor or Color( 0, 0, 0, 0 ) )

        dHeists.cctv.drawCameraHUD( this, self.cameraName, self.cameraPos, self.cameraAng, w, h, self.currentCamera )
    end
end

function FRAME:Flicker( cb )
    self.flickerBackgroundColor = Color( 0, 0, 0, 255 )

    timer.Simple( 0.2, function()
        self.flickerBackgroundColor = nil

        if cb then cb() end
    end )
end

function FRAME:SelectCamera( entity )
    self:Flicker( function()
        self.cameraName = entity:GetCameraName()
        self.cameraPos = entity:GetPos() + entity:GetForward() * 75 + entity:GetRight() * -25
        self.cameraAng = entity:GetAngles() + Angle( 30, 40, 0 )

        self.reverseCameraAng = self.cameraAng + Angle( 0, 30, 0 )
        self.endCameraAng = self.cameraAng + Angle( 0, -30, 0 )

        self.currentCamera = entity

        local x, y = self:GetAbsolutePosition( self.cameraDisplay )

        self.renderData = {
            x = x,
            y = y,
            w = self.cameraDisplay:GetWide(),
            h = self.cameraDisplay:GetTall(),
            origin = self.cameraPos,
            angles = self.cameraAng,
            dopostprocess = false,
            drawhud = false,
            drawviewmodel = false,
            drawmonitors = false
        }
    end )
end

function FRAME:GetAbsolutePosition( panel )
    local positionX, positionY = 0, 0
    panel = panel or self

    while panel do
        local x, y = panel:GetPos()

        positionX, positionY = positionX + x, positionY + y

        panel = panel:GetParent()
    end

    return positionX, positionY
end

function FRAME:AddCamera( entity )
    local button = self.cameraLayout:Add( "DButton" )
    button:SetWide( self.cameraLayout:GetWide() )
    button:SetTall( 40 )
    button:SetText( entity:GetCameraName() )
    button:SetTextColor( color_white )
    button:SetFont( "dHeistsSmall" )
    button:SetExpensiveShadow( 1, Color( 0, 0, 0, 100 ) )

    button.entity = entity

    button.Paint = function( this, w, h )
        local alpha = this:IsDown() and 230 or this:IsHovered() and 180 or 125
        local color = Color( IsValid( entity ) and entity:GetCameraDestroyed() and 100 or 50, 50, 50, alpha )

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

function FRAME:OnRemove()
    net.Start( "dHeists_ViewCCTV" )
    net.SendToServer()
end

vgui.Register( "dHeists_CCTVFrame", FRAME, "DFrame" )

hook.Add( "DrawPhysgunBeam", "dHeists.viewRender", function()
    if suppressDraw then return false end
end )

hook.Add( "PreDrawSkyBox", "dHeists.viewRender", function()
    if suppressDraw then return true end
end )

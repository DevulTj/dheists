--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

local FRAME = {}

local ZONES_TITLE = "Listing %i zone%s"

function FRAME:Init()
    self:SetSize( 256, 256 )
    self:Center()
    self:SetTitle( "Zones" )
    self:MakePopup()

    self:SetSkin( "devUI" )

    self.title = self:Add( "DButton" )
    self.title:Dock( TOP )
    self.title:SetTall( 32 )

    self.desc = self:Add( "DLabel" )
    self.desc:SetText( "Click a zone to start editing." )
    self.desc:Dock( TOP )
    self.desc:SetFont( "devUI_TextSmall" )
    self.desc:SetTall( 20 )
    self.desc:SetContentAlignment( 1 )

    self.createZone = self:Add( "DButton" )
    self.createZone:SetText( "Create Zone" )
    self.createZone:Dock( BOTTOM )
    self.createZone:SetTall( 32 )
    self.createZone:DockMargin( 0, 4, 0, 0 )

    self.createZone.DoClick = function( this )
        dHeists.zoneCreationMenu = vgui.Create( "dHeists.ZoneCreationMenu" )

        self:Remove()
    end

    self.panel = self:Add( "DPanel" )
    self.panel:Dock( FILL )
    self.panel:DockMargin( 0, 4, 0, 0 )

    self.scroll = self.panel:Add( "DScrollPanel" )
    self.scroll:Dock( FILL )

    self.layout = self.scroll:Add( "DIconLayout" )
    self.layout:Dock( FILL )
end

function FRAME:Setup( zoneList )
    self.layout:Clear()

    local count = 0
    for _, zoneName in pairs( zoneList ) do
        count = count + 1

        local button = self.layout:Add( "DButton" )
        button:Dock( TOP )
        button:SetTall( 32 )
        button:SetText( zoneName )
    end

    self.title:SetText( ZONES_TITLE:format( count, count == 1 and "" or "s" ) )
end

function FRAME:OnRemove()
    net.Start( "dHeists.CloseZoneCreator" )
    net.SendToServer()
end

vgui.Register( "dHeists.ZoneList", FRAME, "DFrame" )

FRAME = {}

function FRAME:Init()
    self:SetSize( 256, 64 + 38 )
    self:Center()
    self:SetTitle( "Zone Creator" )
    self:MakePopup()

    self:SetSkin( "devUI" )

    self.textEntry = self:Add( "DTextEntry" )
    self.textEntry:Dock( TOP )
    self.textEntry:SetTall( 32 )
    self.textEntry:SetText( "Zone Name" )

    self.submit = self:Add( "DButton" )
    self.submit:Dock( TOP )
    self.submit:DockMargin( 0, 4, 0, 0 )
    self.submit:SetTall( 32 )
    self.submit:SetText( "Create Zone" )
    self.submit.DoClick = function( this )
        net.Start( "dHeists.CreateZone" )
            net.WriteString( self.textEntry:GetValue() )
        net.SendToServer()

        self:Remove()
    end
end

vgui.Register( "dHeists.ZoneCreationMenu", FRAME, "DFrame" )

net.Receive( "dHeists.OpenZoneCreator", function()
    local zoneList = net.ReadTable()

    local frame = vgui.Create( "dHeists.ZoneList" )
    frame:Setup( zoneList )

    dHeists.zoneList = frame
end )

hook.Add( "PostPlayerDraw", "dHeists.ZoneCreator", function( player )
    if not player:Alive() then return end
    if not player:getDevBool( "inZoneCreator", false ) then return end

    local offset = Vector( 0, 0, 79 )
    local ang = LocalPlayer():EyeAngles()
    local pos = player:GetPos() + offset + ang:Up()

    ang:RotateAroundAxis( ang:Forward(), 90 )
    ang:RotateAroundAxis( ang:Right(), 90 )

    cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.1 )
        draw.DrawText( "dHeists", "dHeistsMassiveItalics", 2 + 2, -23, Color( 0, 0, 0, 125 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "dHeists", "dHeistsMassiveItalics", 2, -25, Color( 150, 150, 150, 125 ), TEXT_ALIGN_CENTER )

        draw.DrawText( "Editing Zones", "dHeistsHuge", 2 + 2, 34, Color( 0, 0, 0, 125 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Editing Zones", "dHeistsHuge", 2, 32, Color( 255, 255, 255, 125 ), TEXT_ALIGN_CENTER )
    cam.End3D2D()
end )
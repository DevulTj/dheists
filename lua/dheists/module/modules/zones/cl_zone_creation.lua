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

net.Receive( "dHeists.OpenZoneCreator", function()
    local zoneList = net.ReadTable()

    local frame = vgui.Create( "dHeists.ZoneList" )
    frame:Setup( zoneList )

    dHeists.zoneList = frame
end )
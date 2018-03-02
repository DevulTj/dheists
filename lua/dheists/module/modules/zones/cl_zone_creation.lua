--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

local FRAME = {}

local ZONES_TITLE = "Listing %i zone%s"

function FRAME:Init()
    self:SetSize( 256, 256 + 34 )
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

    self.reloadAllZones = self:Add( "DButton" )
    self.reloadAllZones:SetText( "Reload All Zones" )
    self.reloadAllZones:Dock( BOTTOM )
    self.reloadAllZones:SetTall( 32 )
    self.reloadAllZones:DockMargin( 0, 4, 0, 0 )
    self.reloadAllZones.Tint = Color( 50, 25, 25 )

    self.reloadAllZones.DoClick = function( this )
        RunConsoleCommand( "dheists_reload_zones" )

        self:Close()
    end

    self.createZone = self:Add( "DButton" )
    self.createZone:SetText( "Create Zone" )
    self.createZone:Dock( BOTTOM )
    self.createZone:SetTall( 32 )
    self.createZone:DockMargin( 0, 4, 0, 0 )

    self.createZone.DoClick = function( this )
        dHeists.zoneCreationMenu = vgui.Create( "dHeists.ZoneCreationMenu" )

        self:Close()
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
    for zoneName, isDynamic in pairs( zoneList ) do
        count = count + 1

        local button = self.layout:Add( "DButton" )
        button:Dock( TOP )
        button:SetTall( 32 )
        button:SetText( zoneName .. ( isDynamic and " (Dynamic)" or "" ) )
        button:SetDisabled( not isDynamic )

        button.DoClick = function( this )
            RunConsoleCommand( "dheists", "editzone", zoneName )

            self:Close()
        end
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

net.Receive( "dHeists.EditZone", function()
    local zoneId = net.ReadUInt( 16 )
    dHeists.currentEditingZone = zoneId

    dHeists.originalZonePos = {}

    for _, entity in pairs( ents.FindByClass( "dheists_*" ) ) do
        if entity.GetZoneID and entity:GetZoneID() == zoneId then
            dHeists.originalZonePos[ entity ] = entity:GetPos()
        end
    end
end )

net.Receive( "dHeists.StopEditZone", function()
    dHeists.currentEditingZone = nil
    dHeists.originalZonePos = nil
    dHeists.newZoneEntities = nil

    if IsValid( dHeists.saveZoneButton ) then dHeists.saveZoneButton:Remove() end
end )

hook.Add( "PostPlayerDraw", "dHeists.ZoneEditor", function( player )
    if not player:Alive() then return end
    if not player:getDevBool( "inZoneEditor", false ) then return end

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

hook.Add( "HUDPaint", "dHeists.ZoneEditor", function()
    local zoneId = dHeists.currentEditingZone
    if not zoneId then return end

    local zoneName = LocalPlayer():getDevString( "zoneEditing" )
    draw.SimpleTextOutlined( dL( "editing_zone", zoneName ), "dHeistsHuge", ScrW() / 2, ScrH() * 0.01, color_white, TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0, 100 ) )
    draw.SimpleTextOutlined( dL "save_zone_prompt", "dHeists_bagTextItalics", ScrW() / 2, ScrH() * 0.065, color_white, TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0, 100 ) )

    if not IsValid( dHeists.saveZoneButton ) then
        local btn = vgui.Create( "DButton" )
        btn:SetSkin( "devUI" )
        btn:SetSize( 256, 32 )
        btn:SetPos( ScrW() / 2 - ( btn:GetWide() / 2 ), ScrH() * 0.095 )
        btn:SetText( dL "save_zone" )

        btn.DoClick = function( this )
            net.Start( "dHeists.SaveZone" )
                net.WriteUInt( zoneId, 16 )

                local newEntities = dHeists.newZoneEntities or {}
                net.WriteTable( newEntities )

                local modifiedEntities = dHeists.modifiedEntities or {}
                for k, v in pairs( modifiedEntities ) do
                    if not IsValid( v ) then
                        modifiedEntities[ k ] = nil
                    end
                end

                local newModifiedEntities = {}
                for k, v in pairs( modifiedEntities ) do
                    table.insert( newModifiedEntities, v )
                end

                net.WriteTable( newModifiedEntities )
            net.SendToServer()
        end

        dHeists.saveZoneButton = btn
    end

    for _, entity in pairs( ents.FindByClass( "dheists_*" ) ) do
        local entityPos = entity:GetPos()
        local data = entityPos:ToScreen()

        if entity:getDevEntity( "creator" ) == LocalPlayer() then
            draw.SimpleTextOutlined( entity.PrintName .. " (New)", "dHeists_bagTextItalics", data.x, data.y, Color( 50, 200, 50 ), TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0, 100 ) )
        end

        if entity.GetZoneID and entity:GetZoneID() == zoneId then
            local hasMoved = dHeists.originalZonePos and dHeists.originalZonePos[ entity ] and dHeists.originalZonePos[ entity ] ~= entity:GetPos()

            dHeists.modifiedEntities = dHeists.modifiedEntities or {}
            if hasMoved and not table.HasValue( dHeists.modifiedEntities, entity ) then
                table.insert( dHeists.modifiedEntities, entity )
            end

            draw.SimpleTextOutlined( entity.PrintName .. ( " (#%s)" ):format( entity:getDevInt( "creationId" ) ), "dHeists_bagTextItalics", data.x, data.y, hasMoved and Color( 50, 50, 200 ) or Color( 200, 50, 50 ), TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0, 100 ) )
        end
    end
end )

hook.Add( "OnEntityCreated", "dHeists.HookZoneCreation", function( entity )
    local zoneId = dHeists.currentEditingZone
    if not zoneId then return end

    timer.Simple( 0, function()
        if not IsValid( entity ) then print( "Entity is not valid" ) return end

        if entity:getDevEntity( "creator" ) == LocalPlayer() then
            dHeists.newZoneEntities = dHeists.newZoneEntities or {}

            table.insert( dHeists.newZoneEntities, entity )
        end
    end )
end )
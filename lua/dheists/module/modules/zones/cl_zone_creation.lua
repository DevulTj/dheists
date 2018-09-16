--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

local FRAME = {}

local ZONES_TITLE = "Listing %i zone%s"

function FRAME:Init()
    self:SetSize( 256, 256 + 34 + 34 + 34 + 16 + 34 )
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

    self.help = self:Add( "DButton" )
    self.help:SetText( dL "help" )
    self.help:Dock( BOTTOM )
    self.help:SetTall( 32 )
    self.help:DockMargin( 0, 4, 0, 0 )

    self.help.DoClick = function( this )
        RunConsoleCommand( "dheists", "dheists" )

        self:Close()
    end

    self.reloaderPanel = self:Add( "DPanel" )
    self.reloaderPanel:Dock( BOTTOM )
    self.reloaderPanel:DockMargin( 0, 4, 0, 0 )
    self.reloaderPanel:DockPadding( 4, 4, 4, 4 )
    self.reloaderPanel:SetTall( 34 + 34 + 8 )

    self.reloadAllZones = self.reloaderPanel:Add( "DButton" )
    self.reloadAllZones:SetText( dL "reload_zones" )
    self.reloadAllZones:Dock( BOTTOM )
    self.reloadAllZones:SetTall( 32 )
    self.reloadAllZones:DockMargin( 0, 4, 0, 0 )

    self.reloadAllZones.DoClick = function( this )
        RunConsoleCommand( "dheists_reload_zones" )

        self:Close()
    end

    self.reloadAllEntities = self.reloaderPanel:Add( "DButton" )
    self.reloadAllEntities:SetText( dL "reload_entities" )
    self.reloadAllEntities:Dock( BOTTOM )
    self.reloadAllEntities:SetTall( 32 )
    self.reloadAllEntities:DockMargin( 0, 4, 0, 0 )

    self.reloadAllEntities.DoClick = function( this )
        RunConsoleCommand( "dheists_reload_ents" )

        self:Close()
    end

    self.createZone = self:Add( "DButton" )
    self.createZone:SetText( dL "create_zone" )
    self.createZone:Dock( BOTTOM )
    self.createZone:SetTall( 32 )
    self.createZone:DockMargin( 0, 4, 0, 0 )

    self.createZone.DoClick = function( this )
        dHeists.zoneCreationMenu = vgui.Create( "dHeists.ZoneCreationMenu" )

        self:Close()
    end

    self.entitySpawner = self:Add( "DButton" )
    self.entitySpawner:SetText( dL "entity_spawner" )
    self.entitySpawner:Dock( BOTTOM )
    self.entitySpawner:SetTall( 32 )
    self.entitySpawner:DockMargin( 0, 4, 0, 0 )

    self.entitySpawner.DoClick = function( this )
        dHeists.entitySpawnerMenu = vgui.Create( "dHeists.EntitySpawnerMenu" )
        dHeists.entitySpawnerMenu:Setup()

        self:Close()
    end

    self.panel = self:Add( "DPanel" )
    self.panel:Dock( FILL )
    self.panel:DockPadding( 4, 4, 4, 4 )
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

        if not isDynamic then
            button:SetTooltip( "This zone is not dynamic - edit configuration files directly or remove it from the files." )
        end

        button.DoClick = function( this )
            RunConsoleCommand( "dheists", "editzone", zoneName )

            self:Close()
        end

        if isDynamic then
            local deleteButton = button:Add( "DButton" )
            deleteButton:Dock( RIGHT )
            deleteButton:SetWide( 6 )
            deleteButton:SetText( "" )
            deleteButton.Tint = Color( 125, 50, 50 )

            deleteButton.PaintOver = function( this, w, h )
                local isHovered = this:IsHovered()

                if not this.inMovement then
                    if isHovered then
                        this.inMovement = true
                        this:SizeTo( 48, this:GetTall(), 0.5, 0, 2.5, function()
                            this.inMovement = false
                        end )
                    else
                        this:SizeTo( 6, this:GetTall(), 0.5, 0, 2.5 )
                    end
                end

                if isHovered then this:SetText( "Delete" ) else this:SetText( "" ) end
            end

            deleteButton.DoClick = function( this )
                Derma_Query( dL "delete_zone_confirmation", "",
                    dL "yes", function()
                        RunConsoleCommand( "dheists", "deletezone", zoneName )
                        self:Close()
                    end,
                    dL "no", function()

                    end
                )
            end
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
    dHeists.zoneListTable = net.ReadTable()

    local frame = vgui.Create( "dHeists.ZoneList" )
    frame:Setup( dHeists.zoneListTable )

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
    draw.SimpleTextOutlined( dL "editing_zone_helper", "dHeists_bagText", ScrW() / 2, ScrH() * 0.01 + 50, color_white, TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0, 100 ) )
    draw.SimpleTextOutlined( dL "save_zone_prompt", "dHeists_bagTextItalics", ScrW() / 2, ScrH() * 0.01 + 50 + 32, color_white, TEXT_ALIGN_CENTER, nil, 2, Color( 0, 0, 0, 100 ) )

    if not IsValid( dHeists.saveZoneButton ) then
        local btn = vgui.Create( "DButton" )
        btn:SetSkin( "devUI" )
        btn:SetSize( 256, 32 )
        btn:SetPos( ScrW() / 2 - ( btn:GetWide() / 2 ), ScrH() * 0.01 )
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
        if not entity._Entity then continue end

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
        if not entity._Entity then return end

        if entity:getDevEntity( "creator" ) == LocalPlayer() then
            dHeists.newZoneEntities = dHeists.newZoneEntities or {}

            table.insert( dHeists.newZoneEntities, entity )
        end
    end )
end )

FRAME = {}

function FRAME:Init()
    self:SetSize( 256, 256 )
    self:Center()
    self:SetTitle( dL "entity_spawner" )
    self:MakePopup()

    self:SetSkin( "devUI" )

    self.goBack = self:Add( "DButton" )
    self.goBack:Dock( BOTTOM )
    self.goBack:SetTall( 32 )
    self.goBack:SetText( dL "go_back" )
    self.goBack.DoClick = function( this )
        if not dHeists.zoneListTable then return end

        local frame = vgui.Create( "dHeists.ZoneList" )
        frame:Setup( dHeists.zoneListTable )

        self:Close()
    end

    self.scroll = self:Add( "DScrollPanel" )
    self.scroll:Dock( FILL )

    self.layout = self.scroll:Add( "DIconLayout" )
    self.layout:Dock( FILL )
end

function FRAME:AddEntity( name, data )
    local button = self.layout:Add( "DButton" )
    button:Dock( TOP )
    button:SetTall( 32 )
    button:SetText( name )

    button.DoClick = function( this )
        -- @TODO: add functionality to spawn the entity

        net.Start( "dHeists.SpawnOtherEntity" )
            net.WriteString( name )
        net.SendToServer()

        self:Close()
    end

    local selectedModel = data.model or "models/error.mdl"

    local icon = button:Add( "SpawnIcon" )
    icon:Dock( LEFT )
    icon:DockMargin( 4, 0, 0, 0 )
    icon:SetWide( button:GetTall() )
    icon:SetModel( selectedModel )

    if selectedModel == "models/error.mdl" then
        icon:Remove()
    end
end

function FRAME:Setup()
    local List = dHeists.ent.list

    for entName, entData in pairs( List ) do
        self:AddEntity( entName, entData )
    end
end

vgui.Register( "dHeists.EntitySpawnerMenu", FRAME, "DFrame" )
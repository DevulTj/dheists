--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com) - {{ user_id }}
]]

function surface.DrawCuteRect(x, y, w, h, gasp, alpha)
    if (not gasp) then
        gasp = 4
    end
    if (! alpha) then
        alpha = 100
    end

    surface.SetDrawColor(0, 0, 0, alpha)
    surface.DrawRect(x, y, w, h)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawRect(x, y, 4 * gasp, gasp)
    surface.DrawRect(x + w - 4 * gasp, y, 4 * gasp, gasp)
    surface.DrawRect(x, y + h - gasp, 4 * gasp, gasp)
    surface.DrawRect(x + w - 4 * gasp, y + h - gasp, 4 * gasp, gasp)
    surface.DrawRect(x, y + gasp, gasp, 4 * gasp)
    surface.DrawRect(x + w - gasp, y + gasp, gasp, 4 * gasp - gasp)
    surface.DrawRect(x, y + gasp + h - 4 * gasp - gasp, gasp, 4 * gasp - gasp)
    surface.DrawRect(x + w - gasp, y + gasp + h - 4 * gasp - gasp, gasp, 4 * gasp - gasp)
end

timer.Simple( 0, function()
    local SKIN = {}

    surface.CreateFont( "devUI_TextSmall", {
        font = "Roboto Light",
        extended = false,
        size = 18,
        weight = 300,
    })

    surface.CreateFont( "devUI_Text", {
        font = "Roboto Light",
        extended = false,
        size = 20,
        weight = 300,
    })

    surface.CreateFont( "devUI_TextMedium", {
        font = "Roboto Light",
        extended = false,
        size = 40,
        weight = 300,
    })

    surface.CreateFont( "devUI_TextLarge", {
        font = "Roboto Light",
        extended = false,
        size = 64,
        weight = 300,
    })

    SKIN.GlowMaterial = Material( "particle/Particle_Glow_04_Additive" )

    SKIN.fontFrame = "devUI_TextSmall"
    SKIN.fontTab = "devUI_TextSmall"
    SKIN.fontButton = "devUI_TextSmall"
    SKIN.Colours = table.Copy( derma.SkinList.Default.Colours )
    SKIN.Colours.Window.TitleActive = Color( 255, 255, 255 )
    SKIN.Colours.Window.TitleInactive = Color( 255, 255, 255 )

    SKIN.Colours.Button.Normal = Color( 225, 225, 225 )
    SKIN.Colours.Button.Hover = Color( 255, 255, 255 )
    SKIN.Colours.Button.Down = Color( 180, 180, 180 )
    SKIN.Colours.Button.Disabled = Color( 185, 35, 35, 100 )

    SKIN.Colours.Label.Dark = Color( 255, 255, 255 )
    SKIN.Colours.Label.Bright = Color( 125, 125, 125 )

    local gradient = Material( "gui/gradient_up" )
    function SKIN:PaintFrame( panel )
        local color = RRL.theme.primaryColor
        local w, h = panel:GetWide(), panel:GetTall()

        local posX, posY = panel:GetPos()
        DisableClipping( true )
            BSHADOWS.BeginShadow()
                draw.RoundedBox( 8, posX, posY, w, h, color_white )
            BSHADOWS.EndShadow( 2, 2, 1 )
        DisableClipping( false )

        draw.RoundedBox( 4, 0, 0, w, h, Color( color.r, color.g, color.b, color.a ) )
        draw.RoundedBoxEx( 4, 0, 0, w, 24, RRL.theme.secondaryColor, true, true, false, false )

        if IsValid( panel.lblTitle ) then
            panel.lblTitle:SetFont( SKIN.fontFrame )
        end

        surface.SetDrawColor( RRL.theme.tertiaryColor )
        surface.SetMaterial( SKIN.GlowMaterial )
        surface.DrawTexturedRect( - w / 2,  - h / 2, w * 2, h * 2 )
    end

    function SKIN:DrawGenericBackground(x, y, w, h)
        surface.SetDrawColor( 0, 0, 0, 100 )
        surface.DrawOutlinedRect( 0, 0, w, h )

        surface.SetDrawColor( RRL.theme.outlineColor )
        surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )
    end

    function SKIN:PaintPanel(panel)
        if panel:GetPaintBackground() then
            local w, h = panel:GetWide(), panel:GetTall()
            surface.SetDrawColor( 0, 0, 0, 100 )
            surface.DrawOutlinedRect( 0, 0, w, h )

            surface.SetDrawColor( RRL.theme.outlineColor )
            surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )
        end
    end

    function SKIN:PaintButton(panel)
        if panel:GetPaintBackground() then
            local w, h = panel:GetWide(), panel:GetTall()
            local alpha = 150

            if panel:GetDisabled() then
                alpha = 10
            elseif panel.Depressed then
                alpha = 200
            elseif panel.Hovered then
                alpha = 180
            end

            local col = Color(
                panel.Tint and panel.Tint.r or RRL.theme.buttonColor.r,
                panel.Tint and panel.Tint.g or RRL.theme.buttonColor.g,
                panel.Tint and panel.Tint.b or RRL.theme.buttonColor.b
            )

            draw.RoundedBox( 0, 0, 0, w, h, Color( col.r, col.g, col.b, alpha ) )

            surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawOutlinedRect(0, 0, w, h)

            surface.SetDrawColor( RRL.theme.outlineColor )
            surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )
        end

        panel:SetFont( "devUI_TextSmall" )
    end

    function SKIN:PaintTextEntry( panel, w, h )
        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor( RRL.theme.outlineColor )
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

    	panel:DrawTextEntryText( color_white, Color( 25, 55, 100, 125 ), Color( 200, 200, 200, 200 ) )
    end

    function SKIN:PaintListViewLine( panel, w, h )
        local col = Color( 0, 0, 0, 50 )
        if panel:IsLineSelected() then col = Color( 25, 55, 100, 25 ) end

        draw.RoundedBox( 0, 0, 0, w, h, col )

        if panel.FontsAssigned then return end
        for k, v in pairs( panel.Columns ) do
            v:SetFont( "devUI_TextSmall" )
        end

        panel.FontsAssigned = true
    end

    function SKIN:PaintListView( panel, w, h )
        surface.SetDrawColor( Color( 0, 0, 0, 100 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end

    function SKIN:PaintVScrollBar( panel, w, h )
    	draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 40, 255 ) )
    end

    function SKIN:PaintScrollBarGrip( panel, w, h )
        if panel:GetPaintBackground() then
            local w, h = panel:GetWide(), panel:GetTall()
            local alpha = 150

            if panel:GetDisabled() then
                alpha = 10
            elseif panel.Depressed then
                alpha = 235
            elseif panel.Hovered then
                alpha = 200
            end

            surface.SetDrawColor( 30, 30, 30, alpha )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( 0, 0, 0, 100 )
            surface.DrawOutlinedRect( 0, 0, w, h )

            surface.SetDrawColor( RRL.theme.outlineColor )
            surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )
        end
    end

    --[[---------------------------------------------------------
    	ButtonDown
    -----------------------------------------------------------]]
    function SKIN:PaintButtonDown( panel, w, h )
        if panel:GetPaintBackground() then
            local w, h = panel:GetWide(), panel:GetTall()
            local alpha = 150

            if panel:GetDisabled() then
                alpha = 10
            elseif panel.Depressed then
                alpha = 235
            elseif panel.Hovered then
                alpha = 200
            end

            surface.SetDrawColor(30, 30, 30, alpha)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawOutlinedRect(0, 0, w, h)

            surface.SetDrawColor(RRL.theme.outlineColor)
            surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
        end
    end

    --[[---------------------------------------------------------
    	ButtonUp
    -----------------------------------------------------------]]
    function SKIN:PaintButtonUp( panel, w, h )
            if panel:GetPaintBackground() then
            local w, h = panel:GetWide(), panel:GetTall()
            local alpha = 150

            if panel:GetDisabled() then
                alpha = 10
            elseif panel.Depressed then
                alpha = 235
            elseif panel.Hovered then
                alpha = 200
            end

            surface.SetDrawColor(30, 30, 30, alpha)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawOutlinedRect(0, 0, w, h)

            surface.SetDrawColor(RRL.theme.outlineColor)
            surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
        end
    end

    function SKIN:PaintCollapsibleCategory( panel, w, h )
        if panel:GetPaintBackground() then
        local w, h = panel:GetWide(), panel:GetTall()
        local alpha = 150

        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(RRL.theme.outlineColor)
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
        end
    end

    --[[---------------------------------------------------------
        PropertySheet
    -----------------------------------------------------------]]
    function SKIN:PaintPropertySheet( panel, w, h )
        -- TODO: Tabs at bottom, left, right

        local ActiveTab = panel:GetActiveTab()
        local Offset = 0
        if ( ActiveTab ) then Offset = ActiveTab:GetTall() - 8 end

        draw.RoundedBox(0, 0, Offset, w, h - Offset, Color(0, 0, 0, 180))

        surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
        surface.DrawOutlinedRect( 0, Offset, w, h - Offset )
    end

    --[[---------------------------------------------------------
        Tab
    -----------------------------------------------------------]]
    function SKIN:PaintTab( panel, w, h )

        if ( panel:GetPropertySheet():GetActiveTab() == panel ) then
            return self:PaintActiveTab( panel, w, h )
        end

        draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 180))

        surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end

    function SKIN:PaintActiveTab( panel, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color(50, 50, 50, 180))

        surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end

    -- I don't think we gonna need minimize button and maximize button.
    function SKIN:PaintWindowMinimizeButton( panel, w, h )
    end

    function SKIN:PaintWindowMaximizeButton( panel, w, h )
    end

    function SKIN:PaintWindowCloseButton( panel, w, h )
        draw.SimpleText("✕", SKIN.fontFrame, w / 1.5, h / 2.2, panel:IsDown() and Color( 125, 125, 125, 255 ) or panel:IsHovered() and Color( 185, 185, 185, 255 ) or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    --[[---------------------------------------------------------
        ComboDownArrow
    -----------------------------------------------------------]]
    function SKIN:PaintComboDownArrow( panel, w, h )

        if ( panel.ComboBox:GetDisabled() ) then
            return self.tex.Input.ComboBox.Button.Disabled( 0, 0, w, h )
        end

        if ( panel.ComboBox.Depressed || panel.ComboBox:IsMenuOpen() ) then
            return self.tex.Input.ComboBox.Button.Down( 0, 0, w, h )
        end

        if ( panel.ComboBox.Hovered ) then
            return self.tex.Input.ComboBox.Button.Hover( 0, 0, w, h )
        end

        self.tex.Input.ComboBox.Button.Normal( 0, 0, w, h )

    end

    --[[---------------------------------------------------------
        ComboBox
    -----------------------------------------------------------]]
    function SKIN:PaintComboBox( panel, w, h )

        self:PaintButton(panel, w, h)

    end

    --[[---------------------------------------------------------
        ComboBox
    -----------------------------------------------------------]]
    function SKIN:PaintListBox( panel, w, h )

        self.tex.Input.ListBox.Background( 0, 0, w, h )

    end

    derma.DefineSkin( "devUI", nil, SKIN )
    derma.RefreshSkins()
end )
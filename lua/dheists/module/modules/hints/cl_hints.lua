--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }}
]]

dHeists.hints = dHeists.hints or {}

local NOTIFICATION = {}

function NOTIFICATION:Init()
    self.text = self:Add( "DLabel" )
    self.text:Dock( FILL )
    self.text:SetContentAlignment( 5 )
    self.text:SetFont( "dHeists_bagTextLargeItalics" )
    self.text:SetTextColor( Color( 255, 255, 255 ) )
    self.text:SetExpensiveShadow( 2, Color( 0, 0, 0, 125 ) )

    self:SetTall( 64 )
end

local FADE_TIME = 0.5

local gradient_r = Material( "vgui/gradient-r" )
local gradient_l = Material( "vgui/gradient-l" )

NOTIFY_SUCCESS = 10
local HINT_TYPE_TO_COLOR = {
    [ NOTIFY_GENERIC ] = Color( 50, 50, 200 ),
    [ NOTIFY_SUCCESS ] = Color( 50, 200, 50 ),
    [ NOTIFY_ERROR ] = Color( 200, 50, 50 ),
    [ NOTIFY_CLEANUP ] = Color( 200, 200, 50 ),
    [ NOTIFY_HINT ] = Color( 50, 100, 200 )
}
local HINT_TYPE_TO_COLOR_BG = {
    [ NOTIFY_GENERIC ] = Color( 25, 25, 35, 200 ),
    [ NOTIFY_SUCCESS ] = Color( 25, 35, 25, 200 ),
    [ NOTIFY_ERROR ] = Color( 35, 25, 25, 200 ),
    [ NOTIFY_CLEANUP ] = Color( 35, 35, 25, 200 ),
    [ NOTIFY_HINT ] = Color( 25, 35, 35, 200 )
}

local color2 = Color( 50, 200, 50, 100 )
function NOTIFICATION:Setup( text, hintType, lifetime )
    surface.SetFont( self.text:GetFont() )

    hintType = hintType or NOTIFY_GENERIC
    self.hintType = hintType

    local textW, _ = surface.GetTextSize( text )

    lifetime = lifetime or 3

    self.text:SetText( text )

    self.targetW = textW + 256

    self:SizeTo( self.targetW, self:GetTall(), FADE_TIME, 0, 1.5, function()
        timer.Simple( lifetime, function()
            if not IsValid( self ) then return end
            self:Close()
        end )
    end )
end

function NOTIFICATION:Close()
    self:AlphaTo( 0, FADE_TIME, 0, function()
        self:Remove()
    end )
end

function NOTIFICATION:Think()
    self:SetPos( ScrW() / 2 - ( self:GetWide() / 2 ), ScrH() * 0.2 )
end

local color = Color( 25, 25, 25, 200 )

function NOTIFICATION:Paint( w, h )
    --draw.RoundedBox( 4, 0, 0, w, h, Color( 200, 50, 50, 200 ) )

    local hintColor = HINT_TYPE_TO_COLOR[ self.hintType ]
    local bgColor = HINT_TYPE_TO_COLOR_BG[ self.hintType ]

    -- Main gradient
    surface.SetMaterial( gradient_r )
    surface.SetDrawColor( bgColor )
    surface.DrawTexturedRect( 0, 0, w / 2, h )

    surface.SetMaterial( gradient_l )
    surface.SetDrawColor( bgColor )
    surface.DrawTexturedRect( w / 2, 0, w / 2, h )

    -- Sub-gradient (TOP)
    surface.SetMaterial( gradient_r )
    surface.SetDrawColor( hintColor )
    surface.DrawTexturedRect( 0, 0, w / 2, 4 )

    surface.SetMaterial( gradient_l )
    surface.SetDrawColor( hintColor )
    surface.DrawTexturedRect( w / 2, 0, w / 2, 4 )

    -- Sub-gradient (BOTTOM)
    surface.SetMaterial( gradient_r )
    surface.SetDrawColor( hintColor )
    surface.DrawTexturedRect( 0, h - 4, w / 2, 4 )

    surface.SetMaterial( gradient_l )
    surface.SetDrawColor( hintColor )
    surface.DrawTexturedRect( w / 2, h - 4, w / 2, 4 )

end

vgui.Register( "dHeistsHint", NOTIFICATION, "DPanel" )

function dHeists.hints:add( text, hintType, lifetime )
    if IsValid( dHeists.currentHint ) then
        dHeists.currentHint:Remove()
    end

    dHeists.currentHint = vgui.Create( "dHeistsHint" )
    dHeists.currentHint:Setup( text, hintType, lifetime )
end

net.Receive( "dHeists.hints.add", function( _ )
    local text = net.ReadString()
    local hintType = net.ReadUInt( 8 )
    local lifetime = net.ReadUInt( 4 )

    dHeists.hints:add( text, hintType, lifetime )
end )
--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.actions = dHeists.actions or {}

surface.CreateFont( "dHeistsLarge", {
	font = dHeists.config.fontFace or "Purista",
	size = 48,
	weight = 0,
	antialias = true
} )

surface.CreateFont( "dHeistsMedium", {
	font = dHeists.config.fontFace or "Purista",
	size = 24,
	weight = 0,
	antialias = true
} )

dHeists.StateText = ""
dHeists.ActionText = ""
dHeists.ActionColor = Color( 255, 0, 0 )
dHeists.ActionStart = 0
dHeists.ActionEnd = 0

local isDying = false

local scrW, scrH = ScrW(), ScrH()
local w, h = scrW * 0.35, 28
local xPos = - w

function dHeists.DrawAction()
	local actionColor = dHeists.ActionColor
	local start, finish = dHeists.ActionStart, dHeists.ActionEnd
	local curTime = CurTime()

	local timeRemainingText = dHeists.ActionTimeRemainingText or "TIME REMAINING"  
	local fraction = 1 - math.TimeFraction( start, finish, curTime )
	if fraction <= 0 then isDying = true end

	if dHeists.ActionDelete or isDying then
		xPos = Lerp(10 * FrameTime(), xPos, - w )

		if xPos < - ( w - 2 ) then
			isDying = false
			xPos = - w
			dHeists.ActionDelete = nil
		end
	else
		xPos = Lerp( 10 * FrameTime(), xPos, ( ( scrW * 0.5 ) - ( w * 0.5 ) ) )
	end

	local x = xPos
	local y = ( scrH * 0.725 ) - ( h * 0.5 )

	surface.SetDrawColor( 35, 35, 35, 100 )
	surface.DrawRect( x, y, w, h )

	surface.SetDrawColor( 0, 0, 0, 120 )
	surface.DrawOutlinedRect( x, y, w, h )

	surface.SetDrawColor( Color( 0, 0, 0, 100 ) )
	surface.DrawRect(x + 4, y + 4, ( w * fraction ) - 8, h - 8 )

	surface.SetDrawColor( actionColor.r, actionColor.g, actionColor.b, 200 )
	surface.DrawRect( x + 4, y + 4, ( w * fraction ) - 8, h - 8 )

	draw.SimpleText( timeRemainingText, "dHeistsMedium", x + 2, y - 22, color_black )
	draw.SimpleText( timeRemainingText, "dHeistsMedium", x, y - 24, color_white )

	local remainingTime = string.FormattedTime( math.max( finish - curTime, 0 ), "%02i:%02i:%02i" )
	draw.SimpleText( remainingTime, "dHeistsMedium", x + w, y - 22, color_black, TEXT_ALIGN_RIGHT )
	draw.SimpleText( remainingTime, "dHeistsMedium", x + w, y - 24, color_white, TEXT_ALIGN_RIGHT )
end

function dHeists.ClearAction()
	dHeists.ActionDelete = true
end

hook.Add( "HUDPaint", "dHeists.Action", function()
	if dHeists.ActionStart == 0 then return end

	dHeists.DrawAction()

	if dHeists.ActionEnd < CurTime() then
		hook.Run( "dHeists.ActionFinished" )
		dHeists.ClearAction()
	end
end )

dHeists.actions.DefaultActionColor = Color(129, 169, 118)

net.Receive( "dHeists.actions.doAction", function()
	timer.Destroy( "dHeists.ActionTimer" )

	local length = net.ReadUInt( 8 )
	local extraData = net.ReadTable() or false

	if extraData then
		LocalPlayer()._dHeistsActionData = extraData
	end

	for key, value in pairs(extraData or {}) do
		dHeists[ key ] = value
	end

	dHeists.ActionStart = CurTime()
	dHeists.ActionEnd = CurTime() + length
	dHeists.HideBigText = true
	dHeists.ActionColor = dHeists.actions.DefaultActionColor

	timer.Create( "dHeists.ActionTimer", length, 1, function()
		net.Start("dHeists.actions.finishAction")
		net.SendToServer()
	end )
end)

hook.Add( "HUDPaint", "dHeists.Actions", function()
	local player = LocalPlayer()
	if not player._dHeistsActionData then return end
	
	if dHeists.ActionDelete then return end

	local extraData = player._dHeistsActionData
	if IsValid( extraData.ent ) then
		if extraData.ent:GetPos():DistToSqr( player:GetPos() ) > ( extraData.entDistance or 4096 ) then
			dHeists.ClearAction()

			timer.Destroy( "dHeists.ActionTimer" )
		end
	end
end )
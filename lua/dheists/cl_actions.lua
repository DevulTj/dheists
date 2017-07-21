--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.actions = dHeists.actions or {}

dHeists.StateText = ""
dHeists.ActionText = ""
dHeists.ActionColor = Color( 255, 0, 0 )
dHeists.ActionStart = 0
dHeists.ActionEnd = 0

local gradient = Material( "gui/gradient" )
function dHeists.DrawAction()
	local actionColor = dHeists.ActionColor
	local start, finish = dHeists.ActionStart, dHeists.ActionEnd
	local curTime = CurTime()
	local scrW, scrH = ScrW(), ScrH()

	local timeRemainingText = dHeists.ActionTimeRemainingText or "TIME REMAINING"

	if finish > curTime then
		local fraction = math.TimeFraction( start, finish, curTime )
		local alpha = fraction * 255

		if alpha > 0 then
			local w, h = scrW * 0.35, 28
			local x, y = ( scrW * 0.5 ) - ( w * 0.5 ), ( scrH * 0.725 ) - ( h * 0.5 )

			surface.DrawCuteRect( x, y, w, h, 2, 100 )

			surface.SetDrawColor( actionColor.r, actionColor.g, actionColor.b, 200 )
			surface.DrawRect( x + 2, y + 2, ( w * fraction ) - 4, h - 4 )

			draw.SimpleText( timeRemainingText, "dHeistsMedium", x + 2, y - 22, color_black )
			draw.SimpleText( timeRemainingText, "dHeistsMedium", x, y - 24, color_white )

			local remainingTime = string.FormattedTime( math.max( finish - curTime, 0 ), "%02i:%02i:%02i" )
			draw.SimpleText( remainingTime, "dHeistsMedium", x + w, y - 22, color_black, TEXT_ALIGN_RIGHT )
			draw.SimpleText( remainingTime, "dHeistsMedium", x + w, y - 24, color_white, TEXT_ALIGN_RIGHT )
		end
	end
end

function dHeists.ClearAction()
	dHeists.StateText = ""
	dHeists.ActionText = ""
	dHeists.ActionColor = Color( 255, 0, 0 )
	dHeists.ActionStart = 0
	dHeists.ActionEnd = 0
	dHeists.ActionTimeRemainingText = nil
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

	dHeists.ActionColor = dHeists.actions.DefaultActionColor
	dHeists.ActionStart = CurTime()
	dHeists.ActionEnd = CurTime() + length

	for key, value in pairs(extraData or {}) do
		dHeists[ key ] = value
	end

	timer.Create( "dHeists.ActionTimer", length, 1, function()
		net.Start( "dHeists.actions.finishAction" )
		net.SendToServer()
	end )
end)

hook.Add( "HUDPaint", "dHeists.Actions", function()
	local player = LocalPlayer()
	if not player._dHeistsActionData then return end

	local extraData = player._dHeistsActionData
	if IsValid( extraData.ent ) then
		if extraData.ent:GetPos():DistToSqr( player:GetPos() ) > ( extraData.entDistance or 4096 ) then
			dHeists.ClearAction()

			timer.Destroy( "dHeists.ActionTimer" )
		end
	end
end )

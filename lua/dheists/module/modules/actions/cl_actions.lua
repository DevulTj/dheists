--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.actions = dHeists.actions or {}

dHeists.actions.actionData = dHeists.actions.actionData or {}

dHeists.actions.actionData = {
    StateText = "",
    ActionText = "",
    ActionColor = Color( 255, 0, 0 ),
    ActionStart = 0,
    ActionEnd = 0
}

local circleMat = Material( "devultj/ring.png", "mips" )
function dHeists.DrawActionCircle( x, y, w, h, perc, color, cirMat )
	render.ClearStencil()
	render.SetStencilEnable( true )
		render.SetStencilWriteMask( 255 )
		render.SetStencilTestMask( 255 )
		render.SetStencilReferenceValue( 1 )
		render.SetStencilFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
		render.SetBlend( 0 )

		surface.SetDrawColor( 0, 0, 0, 1 )
		draw.NoTexture()
		draw.DrawPercRect( x, y, w, h, perc, true )

		render.SetBlend( 1 )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )

        surface.SetDrawColor( color.r, color.g, color.b, color.a )
        surface.SetMaterial( cirMat or circleMat )
        surface.DrawTexturedRect( x - w / 2, y - h / 2, w, h )
	render.SetStencilEnable( false )
end

local gradient = Material( "gui/gradient" )
function dHeists.DrawAction()
    local actionData = dHeists.actions.actionData
	local actionColor = actionData.ActionColor
	local start, finish = actionData.ActionStart, actionData.ActionEnd
	local curTime = CurTime()
	local scrW, scrH = ScrW(), ScrH()

	local timeRemainingText = actionData.ActionTimeRemainingText or "TIME REMAINING"

	if finish > curTime then
		local fraction = math.TimeFraction( start, finish, curTime )
		local alpha = fraction * 255

		if alpha > 0 then
			local w, h = 170, 170
			local x, y = scrW * 0.5, scrH * 0.75

            local color = Color( actionColor.r, actionColor.g, actionColor.b, 255 )
            dHeists.DrawActionCircle( x + 2, y + 2, w, h, fraction, Color( 0, 0, 0, 100 ), circleMat )
            dHeists.DrawActionCircle( x, y, w, h, fraction, color, circleMat )

			draw.SimpleText( timeRemainingText, "dHeists_bagTextItalics", x + 2, y + 7, Color( 0, 0, 0, 150 ), TEXT_ALIGN_CENTER )
			draw.SimpleText( timeRemainingText, "dHeists_bagTextItalics", x, y + 5, color_white, TEXT_ALIGN_CENTER )

			local remainingTime = string.FormattedTime( math.max( finish - curTime, 0 ), "%02i:%02i:%02i" )
			draw.SimpleText( remainingTime, "dHeistsLarge", x, y - 5, Color( 0, 0, 0, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( remainingTime, "dHeistsLarge", x, y - 7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
end

function dHeists.ClearAction()
    dHeists.actions.actionData = {
        StateText = "",
        ActionText = "",
        ActionColor = Color( 255, 0, 0 ),
        ActionStart = 0,
        ActionEnd = 0,

        ActionTimeRemainingText = nil
    }
end

hook.Add( "HUDPaint", "dHeists.Action", function()
	if dHeists.ActionStart == 0 then return end

	dHeists.DrawAction()

	if dHeists.actions.actionData.ActionEnd < CurTime() then
		hook.Run( "dHeists.ActionFinished" )
		dHeists.ClearAction()
	end
end )

dHeists.actions.DefaultActionColor = Color( 129, 169, 118 )

net.Receive( "dHeists.actions.doAction", function()
	timer.Destroy( "dHeists.ActionTimer" )

	local length = net.ReadUInt( 8 )
	local extraData = net.ReadTable() or false

	if extraData then
		LocalPlayer()._dHeistsActionData = extraData
	end

	dHeists.actions.actionData.ActionColor = dHeists.actions.DefaultActionColor
	dHeists.actions.actionData.ActionStart = CurTime()
	dHeists.actions.actionData.ActionEnd = CurTime() + length

	for key, value in pairs( extraData or {} ) do
		dHeists.actions.actionData[ key ] = value
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

	if extraData.HoldKey and not input.IsKeyDown( extraData.HoldKey ) then
		dHeists.ClearAction()
		timer.Destroy( "dHeists.ActionTimer" )
	end
end )

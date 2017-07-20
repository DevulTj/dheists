--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

hook.Add( "PlayerButtonDown", "dHeists.dropBag", function( player, buttonId )
    if player ~= LocalPlayer() then return end
    if IsFirstTimePredicted() then return end

    if buttonId ~= dHeists.config.dropBagKey then return end

    RunConsoleCommand( "dheists_dropbag" )
end )

local roll = 0
hook.Add( "CalcView", "dHeists.drawBag", function( player, origin, angles, fov )
    if roll ~= 0 or ( roll == 0 and player:GetNW2Bool( "dHeists_CarryingBag", false ) ) then
        roll = Lerp( FrameTime() * 10, roll, player:GetNW2Bool( "dHeists_CarryingBag", false ) and dHeists.config.holdingBagAngleOffset or 0)

        local view = {
            origin = origin,
            angles = Angle( angles.p, angles.y, angles.r + roll ),
            fov = fov - 5
        }

        return view
    end
end )
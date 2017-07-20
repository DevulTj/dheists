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
--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

dHeists.pocketWhitelist = {
    [ "dheists_drill_base" ] = function( ent )
        if ent:GetIsDrilling() then return false end

        return true
    end,
}
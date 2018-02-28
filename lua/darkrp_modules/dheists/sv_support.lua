--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local pocketWhitelist = {
    [ "dheists_drill_base" ] = function( ent )
        if ent:GetIsDrilling() then return false end

        return true
    end,
}

hook.Add( "canPocket", "dHeists.disallowPocket", function( player, entity )
    if entity.DHeists and dHeists.config.disablePocket then
        if pocketWhitelist[ entity:GetClass() ] then return pocketWhitelist[ entity:GetClass() ] end

        return false
    end
end )

hook.Add( "canLockpick", "dHeists.robbing", function( client, entity, trace )
    if not entity.IsRobbableEntity then return end

    local typeInfo = dHeists.robbing.getEnt( entity:GetEntityType() )
    if not typeInfo then return end

    if entity:canRob() == false then return end
    if not typeInfo.canLockpick then return end


    return true
end )

hook.Add( "lockpickTime", "dHeists.robbing", function( client, entity )
    if entity.IsRobbableEntity then return dHeists.robbing.getEnt( entity:GetEntityType() ).lockpickTime or 30 end
end )

hook.Add( "onLockpickCompleted", "dHeists.robbing", function( client, succeeded, entity )
    if not entity.IsRobbableEntity then return end
    if not succeeded then return end

    entity:deploy()
end )

--##NoSimplerr##

--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

hook.Add( "canPocket", "dHeists.disallowPocket", function( player, entity )
    if entity.DHeists and dHeists.config.disablePocket then
        if dHeists.pocketWhitelist[ entity:GetClass() ] then return dHeists.pocketWhitelist[ entity:GetClass() ]( entity ) end

        if entity.IsDrill then
            if entity:GetIsDrilling() then return false end

            return true 
        elseif entity.IsBag then
            if #entity.lootItems > 0 then return false end

            return true
        end

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

local function clearHeistPlayer( player, deleteEnts )
    if not player.getBag or not player.getMask then return end

    local bag = player:getBag()
    if bag then
        local bagEnt = dHeists.dropBag( player )

        if deleteEnts then
            SafeRemoveEntity( bagEnt )
        end
    end

    local mask = player:getMask()
    if mask then
        local maskEnt = player:dropMask( true )

        if deleteEnts then
            SafeRemoveEntity( maskEnt )
        end
    end
end

hook.Add( "OnPlayerChangedTeam", "dHeists", function( player, _, __ )
    if dHeists.config.dropBagAndMaskOnTeamChange then
        clearHeistPlayer( player )
    end
end )

hook.Add( "playerArrested", "dHeists", function( player, _, __ )
    if dHeists.config.removeBagAndMaskOnArrest then
        clearHeistPlayer( player, true )
    end
end )

hook.Add( "playerWeaponsConfiscated", "dHeists", function( player, _, __ )
    if dHeists.config.removeBagAndMaskOnWeaponConfiscation then
        clearHeistPlayer( player, true )
    end
end )
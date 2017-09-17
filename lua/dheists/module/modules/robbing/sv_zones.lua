
dHeists._zones = dHeists._zones or {}

gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", dHeists.IDENTIFIER .. "zones", function( data )
    local player = Player( data.userid )

    for zone, _ in pairs( dHeists._zones ) do
        zone:exitPlayer( player )
    end
end )

hook.Add( "EntityCreated", dHeists.IDENTIFIER .. "zones", function( entity )
    if entity.IsZone then
        dHeists._zones[ entity ] = true
    end
end )

hook.Add( "EntityRemoved", dHeists.IDENTIFIER .. "zones", function( entity )
    if entity.IsZone then
        dHeists._zones[ entity ] = nil
    end
end )

hook.Add( "PlayerUse", dHeists.IDENTIFIER .. "zones", function( player, entity )
    if not entity.IsRaidable or not player.inZones then
        return
    end

    for zone, _ in pairs( player.inZones ) do
        if zone:hasCooldown() then
            return false
        end
    end
end )

local PLAYER = FindMetaTable( "Player" )

function PLAYER:addInZone( zone )
    if self.inZones[ zone ] then

        return
    end

    self.inZones[ zone ] = true
end

function PLAYER:removeInZone( zone )
    if not self.inZones[ zone ] then

        return
    end

    self.inZones[ zone ] = nil
end

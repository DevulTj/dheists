--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

util.AddNetworkString( "dHeists_entUse" )

local function spawnEnt( typeInfo, pos, ang )
    local posIsTable = istable( pos )
    local angIsTable = istable( ang )

    local ent = ents.Create( "dheists_ent_base" )
    ent:SetPos( posIsTable and pos[ 1 ] or pos )
    ent:SetAngles( angIsTable and ang[ 1 ] or ang or Angle( 0, 0, 0 ) )
    ent:SetModel( typeInfo.model )

    ent:Spawn()
    ent:setEnt( typeInfo )

    dHeists.print( "Spawning ent at " .. tostring( pos ) .. ", " .. tostring( ang ) )

    ent.pos = pos
    ent.ang = ang

    if typeInfo.rotationTime and posIsTable then
        local timerName = "dHeists.entRotationTimer_" .. ent:EntIndex()

        timer.Create( timerName, typeInfo.rotationTime, 0, function()
            ent:rotatePosition()
        end )

        ent:CallOnRemove( "dHeists.entRotation", function( _ent )
            timer.Remove( timerName )
        end )
    end

    if typeInfo.onSpawn then typeInfo.onSpawn( ent ) end

    return ent
end

function dHeists.ent.spawnEnts()
    for _, entData in pairs( dHeists.ent.list ) do
        local location = dHeists.ent.getEntLocations( entData.name )
        if not location then continue end

        spawnEnt( entData, location.pos, location.ang )
    end
end

hook.Add( "InitPostEntity", "dHeists_createEnts", dHeists.ent.spawnEnts )

concommand.Add( "dheists_reload_ents", function( player )
    local function hasAccessCallback( hasAccess )
        if not hasAccess then return end

        for _, entity in pairs( ents.GetAll() ) do
            if entity.IsDHeistsEnt then
                SafeRemoveEntity( entity )
            end
        end

        dHeists.ent.spawnEnts()
    end

    -- If called by console, they `always` have access.
    if not IsValid( player ) then
        hasAccessCallback( true )

        return
    end

    -- To prevent duplicate code, let's check for non-console units.
    CAMI.PlayerHasAccess( player, dHeists.privileges.RELOAD_ENTS, hasAccessCallback )
end )

hook.Add( "dHeists_entUsed", "dHeists.useEnt", function( ent, name, activator, caller )
    if not IsValid( caller ) then return end
    local entData = dHeists.ent.list[ ent:GetEntType() ]
    if not entData then return end

    -- If there is any clientside feedback required, we can act on it.
    net.Start( "dHeists_entUse" )
        net.WriteString( entData.name )
    net.Send( caller )
end )

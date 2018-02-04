--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

util.AddNetworkString( "dHeists_NPCUse" )

local function spawnNPC( typeInfo, pos, ang )
    local posIsTable = istable( pos )

    local npc = ents.Create( "dheists_npc_base" )
    npc:SetPos( posIsTable and pos[ 1 ] or pos )
    npc:SetAngles( ang or Angle( 0, 0, 0 ) )
    npc:SetModel( typeInfo.model )

    npc:Spawn()
    npc:setNPC( typeInfo )

    dHeists.print( "Spawning NPC at " .. tostring( pos ) .. ", " .. tostring( ang ) )

    npc.pos = pos
    npc.ang = ang

    if typeInfo.rotationTime and posIsTable then
        local timerName = "dHeists.NPCRotationTimer_" .. npc:EntIndex()

        timer.Create( timerName, typeInfo.rotationTime, 0, function()
            npc:rotatePosition()
        end )

        npc:CallOnRemove( "dHeists.NPCRotation", function( ent )
            timer.Remove( timerName )
        end )
    end

    return npc
end

function dHeists.npc.spawnNPCs()
    for _, npcData in pairs( dHeists.npc.list ) do
        local location = dHeists.npc.getNPCLocations( npcData.name )
        if not location then continue end

        spawnNPC( npcData, location.pos, location.ang )
    end
end

hook.Add( "InitPostEntity", "dHeists_createNPCs", dHeists.npc.spawnNPCs )

concommand.Add( "dheists_reload_npc", function( player )
    local function hasAccessCallback( hasAccess )
        if not hasAccess then return end

        for _, entity in pairs( ents.GetAll() ) do
            if entity.IsDHeistsNPC then
                SafeRemoveEntity( entity )
            end
        end

        dHeists.npc.spawnNPCs()
    end

    -- If called by console, they `always` have access.
    if not IsValid( player ) then
        hasAccessCallback( true )

        return
    end

    -- To prevent duplicate code, let's check for non-console units.
    CAMI.PlayerHasAccess( player, dHeists.privileges.RELOAD_NPCS, hasAccessCallback )
end )

hook.Add( "dHeists_NPCUsed", "dHeists.useNPC", function( npc, name, activator, caller )
    if not IsValid( caller ) then return end
    local npcData = dHeists.npc.list[ npc:GetNPCType() ]
    if not npcData then return end

    -- If there is any clientside feedback required, we can act on it.
    net.Start( "dHeists_NPCUse" )
        net.WriteString( npcData.name )
    net.Send( caller )
end )

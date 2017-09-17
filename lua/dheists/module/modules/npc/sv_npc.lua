--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

util.AddNetworkString( "dHeists_NPCUse" )

local function spawnNPC( typeInfo, pos, ang )
    local npc = ents.Create( "dheists_npc_base" )
    npc:SetPos( pos )
    npc:SetAngles( ang or Angle( 0, 0, 0 ) )
    npc:SetModel( typeInfo.model )

    npc:Spawn()
    npc:setNPC( typeInfo )

    dHeists.print( "Spawning NPC at " .. tostring( pos ) .. ", " .. tostring( ang ) )

    return npc
end

function dHeists.npc.spawnNPCs()
    for _, npcData in pairs( dHeists.npc.list ) do
        local location = dHeists.npc.getNPCLocations( npcData.name )
        if not location then continue end

        if istable( location.pos ) then
            for nId, vPos in pairs( location.pos ) do
                spawnNPC( npcData, vPos, location.ang[ nId ] )
            end
        else
            spawnNPC( npcData, location.pos, location.ang )
        end
    end
end

hook.Add( "InitPostEntity", "dHeists_createNPCs", dHeists.npc.spawnNPCs )

concommand.Add( "dheists_reload_npc", function( player )
    if not player:IsSuperAdmin() then return end

    for _, entity in pairs( ents.GetAll() ) do
        if entity.IsDHeistsNPC then
            SafeRemoveEntity( entity )
        end
    end

    dHeists.npc.spawnNPCs()
end )

hook.Add( "dHeists_NPCUsed", "dHeists.useNPC", function( npc, name, activator, caller )
    if not IsValid( caller ) then return end
    local npcData = dHeists.npc.list[ npc:GetNPCType() ]
    if not npcData then return end

    net.Start( "dHeists_NPCUse" )
        net.WriteString( npcData.name )
    net.Send( caller )
end )

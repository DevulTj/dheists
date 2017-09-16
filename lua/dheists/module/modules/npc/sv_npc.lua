--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

util.AddNetworkString( "dHeists_NPCUse" )

dHeists.npc.locations = dHeists.npc.locations or {}

function dHeists.npc.spawnNPCs()
    for _, npcData in pairs( dHeists.npc.list ) do
        local npc = ents.Create( "dheists_npc_base" )
        npc:SetPos( npcData.pos )
        npc:SetAngles( npcData.ang )
        npc:SetModel( npcData.model )

        npc:Spawn()
        npc:setNPC( npcData )

        dHeists.print( "Spawning NPC at " .. tostring( npcData.pos ) )
    end
end

hook.Add( "dHeistsDBInitialized", "dHeists_createNPCs", function()
    dHeists.print( "Database Initialized" )
end )

concommand.Add( "dheists_reload_npc", function( player )
    if not player:IsSuperAdmin() then return end

    for _, entity in pairs( ents.GetAll() ) do
        if entity.IsBaseNPC then
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
        net.WriteUInt( npcData.id, 8 )
    net.Send( caller )
end )

--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

function dHeists.npc.create( name, data )
    local npc = data
    data.name = name

    local id = table.insert( dHeists.npc.list, npc )
    dHeists.npc.list[ id ].id = id

    return id
end

hook.Call( "dHeists.registerNPCs" )

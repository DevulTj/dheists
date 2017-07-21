--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.npc.list = {}

-- DO NOT EDIT ABOVE THIS LINE!

dHeists.LOOT_NPC = dHeists.npc.create( "Loot Guy", {
    model = "models/police.mdl",
    pos = Vector( 1093, 271, -79 ),
    ang = Angle( 0, 135, 0 ),
    useFunc = function( player )

    end,
    startTouch = function( npc, entity )
        dHeists.collectBag( npc, entity )
    end
} )

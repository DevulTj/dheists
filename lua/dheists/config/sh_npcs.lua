--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.npc.list = {}

hook.Add( "dHeists.registerNPCs", dHeists.IDENTIFIER, function()

-- DO NOT EDIT ANYTHING ABOVE THIS LINE!

dHeists.NPC_BAGS = dHeists.npc.create( "Loot Guy", {
    model = "models/police.mdl",
    pos = Vector( 1093, 271, -79 ),
    ang = Angle( 0, 135, 0 ),
    useFunc = function( player )

    end,
    startTouch = function( npc, entity )
        dHeists.collectBag( npc, entity )
    end
} )

-- DO NOT EDIT ANYTHING BELOW THIS LINE!

end )

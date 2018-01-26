--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.npc.create( "Loot Guy", {
    model = "models/police.mdl",
    useFunc = function( player )

    end,
    startTouch = function( npc, entity )
        dHeists.collectBag( npc, entity )
    end
} )

dHeists.npc.addLocation( "gm_construct", "Loot Guy", {
    pos = Vector( 1093, 271, -79 ),
    ang = Angle( 0, 135, 0 ),
} )

dHeists.npc.addLocation( "gm_flatgrass", "Loot Guy", {
    pos = Vector( -580, -34, -12223 ),
    ang = Angle( 0, 135, 0 ),
} )
--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]


hook.Add( "dHeists.robbing.registerEnt", dHeists.IDENTIFIER, function()

-- DO NOT EDIT ANYTHING ABOVE THIS LINE!

dHeists.ROBBING_SAFETY_DEPOSIT_BOX = dHeists.robbing:registerEnt( "Safety Deposit Box", {
    model = "models/hunter/blocks/cube05x05x05.mdl",
    material = "phoenix_storms/dome",

    canDrill = true,
    canLockpick = true,

    loot = {
        [ "Small Roll of Cash" ] = true
    }
} )

dHeists.ROBBING_SMALL_VAULT = dHeists.robbing:registerEnt( "Small Vault", {
    model = "models/hunter/blocks/cube1x1x1.mdl",
    material = "phoenix_storms/metalfloor_2-3",

    canDrill = true,
    drillPos = Vector( 0, 35, 0 ),
    drillAng = Angle( 0, -90, 0 ),

    loot = {
        "Small Roll of Cash",
        "Case of Cash",
        "SecuroServ Golden Figure",
        "SecuroServ Silver Figure"
    },
    lootSpawnPoint = Vector( 0, 50, 0 )
} )

-- DO NOT EDIT ANYTHING BELOW THIS LINE!

end )

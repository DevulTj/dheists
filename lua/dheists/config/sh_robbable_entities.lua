--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]


hook.Add( "dHeists.robbing.registerEnt", dHeists.IDENTIFIER, function()

-- DO NOT EDIT ANYTHING ABOVE THIS LINE!

dHeists.robbing:registerEnt( "Safety Deposit Box", {
    model = "models/hunter/blocks/cube05x05x05.mdl",
    material = "phoenix_storms/dome",

    canDrill = true,
    canLockpick = true,

    loot = {
        "Small Roll of Cash"
    }
} )

dHeists.robbing:registerEnt( "Small Vault", {
    model = "models/devultj/safe.mdl",
    loot = {
        "Small Roll of Cash",
        "Case of Cash",
        "SecuroServ Golden Figure",
        "SecuroServ Silver Figure"
    },

    -- Cooldown between robberies
    cooldown = 30,

    -- Animation properties
    openSequence = "open",
    closeSequence = "close",

    -- Positions, angles
    drillPos = Vector( 38, 0, 25 ),
    drillAng = Angle( 0, 180, 0 ),
    lootSpawnPoint = Vector( 40, 0, 25 ),

    canDrill = true
} )

-- DO NOT EDIT ANYTHING BELOW THIS LINE!

end )

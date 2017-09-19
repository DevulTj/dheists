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

    canDrill = true,
    drillPos = Vector( 38, 0, 25 ),
    drillAng = Angle( 0, 180, 0 ),

    loot = {
        "Small Roll of Cash",
        "Case of Cash",
        "SecuroServ Golden Figure",
        "SecuroServ Silver Figure"
    },
    lootSpawnPoint = Vector( 0, 50, 0 ),

    onFinish = function( entity )
        entity:SetSequence( entity:LookupSequence( "open" ) )
    end
} )

-- DO NOT EDIT ANYTHING BELOW THIS LINE!

end )

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
    lootSpawnPoint = Vector( 40, 0, 25 ),

    onFinish = function( entity )
        entity:SetPlaybackRate( 0.2 )
        entity:SetSequence( 1 )

        timer.Simple( 5, function()
            if not IsValid( entity ) then return end

            entity:SetSequence( 3 )
        end )
    end
} )

-- DO NOT EDIT ANYTHING BELOW THIS LINE!

end )

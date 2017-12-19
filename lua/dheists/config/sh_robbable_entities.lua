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

    -- Positions, angles
    drillPos = Vector( 38, 0, 25 ),
    drillAng = Angle( 0, 180, 0 ),
    lootSpawnPoint = Vector( 40, 0, 25 ),

    canDrill = true,
    -- Ensures that the loot doesn't spawn automatically
    customLootSpawn = true,

    onFinish = function( entity )
        -- Run the open sequence
        local sequenceId = entity:LookupSequence( "open" )
        entity:ResetSequence( sequenceId )

        -- Delay spawning & animation reset until the open animation has finished
        timer.Simple( entity:SequenceDuration( sequenceId ), function()
            if not IsValid( entity ) then return end

            -- Manually spawn loot
            entity.spawnLoot()

            entity:ResetSequence( entity:LookupSequence( "close" ) )
        end )
    end
} )

-- DO NOT EDIT ANYTHING BELOW THIS LINE!

end )

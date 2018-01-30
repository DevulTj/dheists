--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.robbing:registerEnt( "Safety Deposit Box", {
    model = "models/hunter/blocks/cube05x05x05.mdl",
    material = "phoenix_storms/dome",

    canDrill = true,
    canLockpick = true,

    loot = {
        "loot_cash_roll_small"
    }
} )
--
dHeists.robbing:registerEnt( "Small Vault", {
    model = "models/devultj/safe.mdl",
    loot = {
        "loot_cash_roll_small",
        "loot_cash_case",
        "loot_golden_figure",
        "loot_silver_figure"
    },

    -- Cooldown between robberies
    cooldown = 300,

    -- Animation properties
    openSequence = "open",
    closeSequence = "close",

    -- Positions, angles
    drillPos = Vector( 38, 0, 25 ),
    drillAng = Angle( 0, 180, 0 ),
    lootSpawnPoint = Vector( 40, 0, 25 ),

    canDrill = true
} )

--
dHeists.robbing:registerEnt( "Item Crate", {
    model = "models/Items/item_item_crate.mdl",
    loot = {
        "loot_cash_roll_small",
        "loot_silver_figure"
    },

    canLockpick = true,
    lockpickTime = 5,

    canDrill = false,

    -- Cooldown between robberies
    cooldown = 10,

    -- Positions, angles
    lootSpawnPoint = Vector( 25, 0, 12 ),
} )
--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }}
]]

dHeists.robbing:registerEnt( "Safety Deposit Box", {
    model = "models/props/cs_office/file_cabinet1_group.mdl",
    --material = "phoenix_storms/dome",

    canDrill = true,
    canLockpick = true,

    loot = {
        "loot_cash_roll_small",
        "loot_diamond_figure",
        "loot_golden_figure",
        "loot_silver_figure",
    },

    drillTime = 20,

    cooldown = 60 * 60,
    lootSpawnPoint = Vector( 15, 0, 35 ),
    drillPos = Vector( 25, 0, 35 ),
    drillAng = Angle( 0, 180, 0 ),
} )
--
dHeists.robbing:registerEnt( "Small Vault", {
    model = "models/devultj/safe.mdl",
    loot = {
        "loot_diamond_figure",
        "loot_cash_crate",
        "loot_cash_case",
    },

    -- Cooldown between robberies
    cooldown = 60 * 60,

    -- Animation properties
    openSequence = "open",
    closeSequence = "close",

    -- Positions, angles
    drillPos = Vector( 38, 0, 25 ),
    drillAng = Angle( 0, 180, 0 ),
    lootSpawnPoint = Vector( 10, 0, 25 ),
    textPos = Vector( 45, 38, 25 ),
    textAng = Angle( 0, -30, 0 ),
    drillTime = 480,

    canDrill = true,

    customLootSpawn = true,

    onSpawn = function( ent )
        ent:SetBodygroup( 1, 1 )
    end,

    onFinish = function( ent, data )
        ent:SetBodygroup( 1, 0 )
        ent:SetBodygroup( 2, 1 )

        ent:spawnLoot()

        timer.Simple( data.cooldown or 60, function()
            if not IsValid( ent ) then return end

            ent:SetBodygroup( 2, 0 )
            ent:SetBodygroup( 1, 1 )
        end )
    end
} )

--
dHeists.robbing:registerEnt( "Item Crate", {
    model = "models/Items/item_item_crate.mdl",
    loot = {
        "loot_cash_roll_small",
        "loot_golden_figure"
    },

    canLockpick = true,
    lockpickTime = 5,

    canDrill = false,

    -- Cooldown between robberies
    cooldown = 60 * 60,

    -- Positions, angles
    lootSpawnPoint = Vector( 25, 0, 12 ),
} )
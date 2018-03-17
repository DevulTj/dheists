--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }}
]]

dHeists.LOOT_MULTIPLIER = 2

dHeists.LOOT_CASH_ROLL_SMALL = dHeists.loot:registerLoot( "loot_cash_roll_small", {
    model = "models/mark2580/gtav/mp_office_03c/accessories/swag_counterfeit1.mdl",
    moneyGiven = 500 * dHeists.LOOT_MULTIPLIER
} )

dHeists.LOOT_SECUROSERV_DIAMOND_FIGURE = dHeists.loot:registerLoot( "loot_diamond_figure", {
    model = "models/mark2580/gtav/mp_office_03c/accessories/award_diamond.mdl",
    moneyGiven = 5000 * dHeists.LOOT_MULTIPLIER,
    actionTime = 2
} )

dHeists.LOOT_SECUROSERV_GOLDEN_FIGURE = dHeists.loot:registerLoot( "loot_golden_figure", {
    model = "models/mark2580/gtav/mp_office_03c/accessories/award_gold.mdl",
    moneyGiven = 2000 * dHeists.LOOT_MULTIPLIER,
    actionTime = 2
} )

dHeists.LOOT_SECUROSERV_SILVER_FIGURE = dHeists.loot:registerLoot( "loot_silver_figure", {
    model = "models/mark2580/gtav/mp_office_03c/accessories/award_silver.mdl",
    moneyGiven = 500 * dHeists.LOOT_MULTIPLIER,
    actionTime = 1
} )

dHeists.LOOT_CASH_CASE = dHeists.loot:registerLoot( "loot_cash_case", {
    model = "models/mark2580/gtav/mp_office_03c/accessories/cash_case.mdl",
    moneyGiven = 2000 * dHeists.LOOT_MULTIPLIER,
    actionTime = 2
} )

dHeists.LOOT_CASH_CRATE = dHeists.loot:registerLoot( "loot_cash_crate", {
    model = "models/mark2580/gtav/mp_office_03c/accessories/cash_crate_01.mdl",
    moneyGiven = 10000 * dHeists.LOOT_MULTIPLIER,
    actionTime = 3
} )

--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]


hook.Add( "dHeists.loot.registerLoot", dHeists.IDENTIFIER, function()

-- DO NOT EDIT ANYTHING ABOVE THIS LINE!

dHeists.LOOT_CASH_ROLL_SMALL = dHeists.loot.registerLoot( "Small Roll of Cash", {
    model = "models/mark2580/gtav/mp_office_03c/accessories/swag_counterfeit1.mdl",
    moneyGiven = 250
} )

dHeists.LOOT_SECUROSERV_GOLDEN_FIGURE = dHeists.loot.registerLoot( "SecuroServ Golden Figure", {
    model = "models/mark2580/gtav/mp_office_03c/accessories/award_gold.mdl",
    moneyGiven = 1250,
    actionTime = 2
} )

dHeists.LOOT_SECUROSERV_SILVER_FIGURE = dHeists.loot.registerLoot( "SecuroServ Silver Figure", {
    model = "models/mark2580/gtav/mp_office_03c/accessories/award_silver.mdl",
    moneyGiven = 500,
    actionTime = 1
} )

dHeists.LOOT_CASH_CASE = dHeists.loot.registerLoot( "Case of Cash", {
    model = "models/mark2580/gtav/mp_office_03c/accessories/cash_case.mdl",
    moneyGiven = 1000,
    actionTime = 2
} )

-- DO NOT EDIT ANYTHING BELOW THIS LINE!

end )

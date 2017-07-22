--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.config.debugEnabled = --[[not game.IsDedicated()]] false

dHeists.config.drillModel = "models/hunter/blocks/cube05x05x05.mdl" -- Leave to default if you don't know what to do with this
dHeists.config.drillMaterial = nil -- You can set custom materials for the drill

dHeists.config.bagModel = "models/jessev92/payday2/item_Bag_loot.mdl" -- Leave to default if you don't know what to do with this
dHeists.config.bagSkin = 2 -- You can set a skin for the bag

dHeists.config.currency = "£"

dHeists.config.fontFace = "Purista"
dHeists.config.fontWeight = 800 -- 800 is bold, 0 is skinny

dHeists.config.bagPickUpTime = 2
dHeists.config.alternateBagPos = true

dHeists.config.holdingBagMovementModifier = 0.7 -- 25% less movement speed

dHeists.config.defaultBagThrowStrength = 300
dHeists.config.defaultBagThrowStrengthSprintMultiplier = 2
dHeists.config.holdingBagAngleOffset = 10 -- 10 degrees
dHeists.config.dropBagCommand = "dheists_dropbag"
dHeists.config.dropBagKey = KEY_G

dHeists.config.confiscateBagActionColor = Color( 20, 20, 151 )
dHeists.config.confiscateBagActionText = "CONFISCATING BAG"
dHeists.config.confiscateBagMoneyPrize = 1250
dHeists.config.bagConfiscateTime = 4

dHeists.config.confiscateBagText = "You gained %s from confiscating a Bag"
dHeists.config.bagCollectedText = "You gained %s from selling %s"

dHeists.config.pickUpBagActionColor = Color( 20, 151, 20 )
dHeists.config.pickUpBagActionText = "PICKING UP BAG"

dHeists.config.stealPickUpBagActionColor = Color( 255, 165, 20 )
dHeists.config.stealPickUpBagActionText = "STEALING BAG"
dHeists.config.stealPickUpBagTime = 4

dHeists.config.pickUpLootActionColor = Color( 20, 151, 20 )
dHeists.config.pickUpLootActionText = "PICKING UP LOOT"

dHeists.config.isPoliceFunction = function( player )
    return player:getJobTable().category == "Civil Protection"
end

dHeists.config.addMoneyFunction = function( player, amount )
    return player:addMoney( amount )
end

dHeists.config.addNotificationFunction = function( player, text )
    return DarkRP and DarkRP.notify( player, 0, 4, text ) or player:ChatPrint( text )
end

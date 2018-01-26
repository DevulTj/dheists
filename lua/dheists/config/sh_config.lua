--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.config.debugEnabled = not game.IsDedicated()
dHeists.config.debugEnabled = false

dHeists.config.drillModel = "models/monmonstar/pd2_drill/drill_small.mdl" -- Leave to default if you don't know what to do with this
dHeists.config.drillMaterial = nil -- You can set custom materials for the drill

dHeists.config.bagModel = "models/jessev92/payday2/item_Bag_loot.mdl" -- Leave to default if you don't know what to do with this
dHeists.config.defaultBagCapacity = 4

dHeists.config.currency = "$"

dHeists.config.fontFace = "Purista"
dHeists.config.fontWeight = 800 -- 800 is bold, 0 is skinny

dHeists.config.bagPickUpTime = 2
dHeists.config.alternateBagPos = false

dHeists.config.holdingBagMovementModifierPerItem = 0.1 -- 10% less per item
dHeists.config.holdingBagMovementModifierMax = 0.3 -- 30% max movement speed reduction

dHeists.config.defaultBagThrowStrength = 300
dHeists.config.defaultBagThrowStrengthSprintMultiplier = 2
dHeists.config.holdingBagAngleOffset = 5 -- 10 degrees
dHeists.config.dropBagCommand = "dheists_dropbag"
dHeists.config.dropBagKey = KEY_G

dHeists.config.maskEquipKey = KEY_H

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

dHeists.config.robberyTime = 60

dHeists.config.isPoliceFunction = function( player )
    return player:getJobTable().category == "Civil Protection"
end

dHeists.config.addMoneyFunction = function( player, amount )
    return player:addMoney( amount )
end

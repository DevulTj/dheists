--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }}
]]

dHeists.config.debugEnabled = not game.IsDedicated()
dHeists.config.debugEnabled = false

dHeists.config.disablePlayerDrawHook = true

dHeists.config.drillModel = "models/monmonstar/pd2_drill/drill_small.mdl" -- Leave to default if you don't know what to do with this
dHeists.config.drillMaterial = nil -- You can set custom materials for the drill
dHeists.config.drillWorth = 2500
dHeists.config.drillTeams = {
    "Gangster",
    "Mob boss"
}

dHeists.config.bagModel = "models/jessev92/payday2/item_Bag_loot.mdl" -- Leave to default if you don't know what to do with this
dHeists.config.defaultBagCapacity = 4

dHeists.config.currency = "$"

dHeists.config.fontFace = "Purista"
dHeists.config.fontWeight = 800 -- 800 is bold, 0 is skinny

dHeists.config.bagPickUpTime = 2
dHeists.config.alternateBagPos = false -- Places bags rotated on the player's back.

dHeists.config.holdingBagMovementModifierPerItem = 0.025 -- 10% less per item
dHeists.config.holdingBagMovementModifierMax = 0.2 -- 30% max movement speed reduction

dHeists.config.defaultBagThrowStrength = 300
dHeists.config.defaultBagThrowStrengthSprintMultiplier = 2
dHeists.config.holdingBagAngleOffset = 5 -- 10 degrees
dHeists.config.dropBagCommand = "dheists_dropbag"

dHeists.config.dropBagKey = KEY_J
dHeists.config.maskEquipKey = KEY_H

dHeists.config.confiscateBagActionColor = Color( 20, 20, 151 )
dHeists.config.confiscateBagMoneyPrize = 1250
dHeists.config.bagConfiscateTime = 4

dHeists.config.pickUpBagActionColor = Color( 20, 151, 20 )

dHeists.config.stealPickUpBagActionColor = Color( 255, 165, 20 )
dHeists.config.stealPickUpBagTime = 4

dHeists.config.pickUpLootActionColor = Color( 20, 151, 20 )

dHeists.config.playMaskEquipSound = true
dHeists.config.maskOnSounds = {
    male = {
        "vo/npc/male01/getdown02.wav",
        "vo/npc/male01/letsgo01.wav",
        "vo/npc/male01/letsgo02.wav",
        "vo/npc/male01/okimready01.wav"
    },
    female = {
        "vo/npc/female01/getdown02.wav",
        "vo/npc/female01/letsgo01.wav",
        "vo/npc/female01/letsgo02.wav"
    }
}

--[[ Disallow pocketing dHeist entities: ADVISED to keep to true ]]
dHeists.config.disablePocket = true

dHeists.config.cameraRespawnTime = 600
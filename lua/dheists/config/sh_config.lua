--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

dHeists.config.debugEnabled = false

dHeists.config.disablePlayerDrawHook = true

dHeists.config.drillModel = "models/monmonstar/pd2_drill/drill_small.mdl" -- Leave to default if you don't know what to do with this
dHeists.config.drillMaterial = nil -- You can set custom materials for the drill
dHeists.config.drillWorth = 2500
dHeists.config.drillTeams = {
    "Gangster",
    "Mob boss"
}

--[[ Drill destroy reward for cops enabled ]]
dHeists.config.drillDestroyRewardEnabled = true
--[[ Time taken to destroy a drill (ACTION) - seconds ]]
dHeists.config.drillDestroyTime = 5
--[[ Money gained from a police officer destroying a drill ]]
dHeists.config.drillDestroyMoneyPrize = 500
--[[ Action Color ]]
dHeists.config.drillDestroyActionColor = Color( 50, 50, 200 )

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

dHeists.config.confiscateBagActionColor = Color( 50, 50, 200 )
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

--[[ Determines how many police should be online for a robbery to start ]]
dHeists.config.minJobOnlineForRobbery = 3

--[[ JOBS defined by your gamemode's job list ]]
dHeists.config.defaultCopJobs = {
    [ "Civil Protection" ] = true,
    [ "Civil Protection Chief" ] = true,
    [ "SWAT" ] = true
}

--[[ CATEGORIES defined by your gamemode's category list ]]
dHeists.config.defaultCopCategories = {
    [ "Police" ] = true,
    [ "Government" ] = true
}

--[[ Controls tilt when using a bag ]]
dHeists.config.disableBagTilt = false

--[[ Controls whether tracking utility is disabled - NOTE: we only track IP, and public information for statistical efforts. ]]
dHeists.config.disableServerTracking = false

--[[ [DARK RP] Should equipped masks and bags be confiscated on weapon confiscation? ]]
dHeists.config.removeBagAndMaskOnWeaponConfiscation = true

--[[ [DARK RP] Should bags and masks be dropped on team change? ]]
dHeists.config.dropBagAndMaskOnTeamChange = true

--[[ [DARK RP] Should bags and masks be removed on arrest? ]]
dHeists.config.removeBagAndMaskOnArrest = true

-- [HINTS] Should the hints flow downwards or upwards?
-- "Down" or "Up" works
dHeists.config.notificationDirection = "Up"

-- [HINTS] Position of hints
-- "Top" or "Bottom" works
dHeists.config.notificationPosition = "Top"

--[[ [ITEM STORE] Should support for ItemStore be disabled if it is found? ]]
dHeists.config.itemStoreDisabled = false

--[[ [ITEM STORE] Should items registered in ItemStore be stackable? ]]
dHeists.config.itemStoreStackableItem = true

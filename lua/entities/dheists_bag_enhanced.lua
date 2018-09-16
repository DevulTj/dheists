--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

AddCSLuaFile()
DEFINE_BASECLASS( "dheists_bag_base" )

ENT.Base = "dheists_bag_base"
ENT.PrintName = "Enhanced Bag"
ENT.Category = "dHeists - Bags"
ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsBag = true

--[[ dHeists configuration ]]
ENT.BagModel = "models/jessev92/payday2/item_Bag_loot.mdl"
ENT.BagPos = dHeists.config.alternateBagPos and Vector( -7, -5, 0 ) or Vector( 0, 0, 10 )
ENT.BagAng = dHeists.config.alternateBagPos and Angle( 90, 0, 110 ) or Angle( 80, 100, 20 )
ENT.BagScale = dHeists.config.alternateBagPos and 0.8 or 1

ENT.BagCapacity = 6
ENT.BagSkin = 2

-- DarkRP/MonolithRP
ENT.BagLevel = 75
ENT.BagPrice = 10000

-- DarkRP
ENT.BagTeams = {
	"Gangster",
	"Mob boss"
}
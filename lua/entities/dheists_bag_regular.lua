--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

AddCSLuaFile()
DEFINE_BASECLASS( "dheists_bag_base" )

ENT.Base = "dheists_bag_base"
ENT.PrintName = "Regular Bag"
ENT.Category = "dHeists - Bags"
ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsBag = true

--[[ dHeists configuration ]]
ENT.BagModel = "models/jessev92/payday2/item_Bag_loot.mdl"
ENT.BagPos = dHeists.config.alternateBagPos and Vector( -7, -5, 0 ) or Vector( 0, 0, 10 )
ENT.BagAng = dHeists.config.alternateBagPos and Angle( 90, 0, 110 ) or Angle( 80, 100, 20 )
ENT.BagScale = dHeists.config.alternateBagPos and 0.8 or 1

ENT.BagCapacity = 2
ENT.BagSkin = 0

-- DarkRP/MonolithRP
ENT.BagLevel = 25
ENT.BagPrice = 2500

-- DarkRP
ENT.BagTeams = {
	"Gangster",
	"Mob boss"
}

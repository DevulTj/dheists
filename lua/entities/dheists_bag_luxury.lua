--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

AddCSLuaFile()
DEFINE_BASECLASS( "dheists_bag_base" )

ENT.PrintName = "Luxury Bag"
ENT.Category = "dHeists - Bags"
ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsBag = true

--[[ dHeists configuration ]]
ENT.BagCapacity = 4
ENT.BagSkin = 1

-- DarkRP/MonolithRP
ENT.BagLevel = 50
ENT.BagPrice = 5000

-- DarkRP
ENT.BagTeams = {
	"Gangster",
	"Mob boss"
}
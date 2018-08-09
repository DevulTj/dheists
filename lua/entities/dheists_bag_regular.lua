--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

AddCSLuaFile()
DEFINE_BASECLASS( "dheists_bag_base" )

ENT.PrintName = "Regular Bag"
ENT.Category = "dHeists - Bags"
ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsBag = true

--[[ dHeists configuration ]]
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
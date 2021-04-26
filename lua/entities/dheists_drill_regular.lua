--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

AddCSLuaFile()
DEFINE_BASECLASS( "dheists_drill_base" )

ENT.PrintName = "Regular Drill"
ENT.Category = "dHeists - Drills"
ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsDrill = true

--[[ dHeists configuration ]]
ENT.DrillTimeNormal = 1
ENT.DrillSkin = 0
ENT.DrillScale = 0.8

-- DarkRP/MonolithRP
ENT.DrillLevel = 25
ENT.DrillPrice = 2500

-- DarkRP
ENT.BagTeams = {
	"Gangster",
	"Mob boss"
}

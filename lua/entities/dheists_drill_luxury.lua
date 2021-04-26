--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

AddCSLuaFile()
DEFINE_BASECLASS( "dheists_drill_base" )

ENT.PrintName = "Luxury Drill"
ENT.Category = "dHeists - Drills"
ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsDrill = true

--[[ dHeists configuration ]]
ENT.DrillTimeNormal = 0.85
ENT.DrillSkin = 1
ENT.DrillScale = 1

-- DarkRP/MonolithRP
ENT.DrillLevel = 50
ENT.DrillPrice = 5000

-- DarkRP
ENT.BagTeams = {
	"Gangster",
	"Mob boss"
}

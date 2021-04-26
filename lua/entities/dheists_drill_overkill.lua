--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

AddCSLuaFile()
DEFINE_BASECLASS( "dheists_drill_base" )

ENT.PrintName = "Overkill Drill"
ENT.Category = "dHeists - Drills"
ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsDrill = true

--[[ dHeists configuration ]]
ENT.DrillTimeNormal = 0.5
ENT.DrillSkin = 3
ENT.DrillScale = 1.5

-- DarkRP/MonolithRP
ENT.DrillLevel = 100
ENT.DrillPrice = 10000

-- DarkRP
ENT.BagTeams = {
	"Gangster",
	"Mob boss"
}

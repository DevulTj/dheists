--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

AddCSLuaFile()
DEFINE_BASECLASS( "dheists_drill_base" )

ENT.PrintName = "Enhanced Drill"
ENT.Category = "dHeists - Drills"
ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsDrill = true

--[[ dHeists configuration ]]
ENT.DrillTimeNormal = 0.6
ENT.DrillSkin = 2
ENT.DrillScale = 1.1

-- DarkRP/MonolithRP
ENT.DrillLevel = 75
ENT.DrillPrice = 7500

-- DarkRP
ENT.BagTeams = {
	"Gangster",
	"Mob boss"
}
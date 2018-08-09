--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

AddCSLuaFile()
DEFINE_BASECLASS( "dheists_drill_base" )

ENT.PrintName = "Luxury Drill"
ENT.Category = "dHeists - Drills"
ENT.Spawnable = true
ENT.AdminSpawnable	= true

--[[ dHeists configuration ]]
ENT.DrillTimeNormal = 0.85
ENT.DrillSkin = 1
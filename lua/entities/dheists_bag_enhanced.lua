--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

AddCSLuaFile()
DEFINE_BASECLASS( "dheists_bag_base" )

ENT.PrintName = "Enhanced Bag"
ENT.Category = "dHeists - Bags"
ENT.Spawnable = true
ENT.AdminSpawnable	= true

--[[ dHeists configuration ]]
ENT.BagCapacity = 6
ENT.BagSkin = 2
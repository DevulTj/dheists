--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

AddCSLuaFile()
DEFINE_BASECLASS( "dheists_mask_base" )

ENT.Base = "dheists_mask_base"
ENT.Type = "anim"
ENT.Author = "DevulTj"
ENT.PrintName = "Hoxton Mask"
ENT.Category = "dHeists - Masks"

ENT.Spawnable = true
ENT.AdminSpawnable	= true

ENT.IsMask = true

ENT.MaskModel = "models/shaklin/payday2/masks/pd2_mask_hoxton.mdl"
ENT.MaskPos = Vector( 1, 0, -3 )
ENT.MaskAng = Angle( 90, 180, 90 )
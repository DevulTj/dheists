

--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }}
]]

local ENTITY = FindMetaTable( "Entity" )
local PREFIX = dHeists.IDENTIFIER .. "_"

function ENTITY:setDevString( key, value )
	return self:SetNW2String( PREFIX .. key, value )
end

function ENTITY:getDevString( key, fallbackValue )
	return self:GetNW2String( PREFIX .. key, fallbackValue )
end

function ENTITY:setDevInt( key, value )
	return self:SetNW2Int( PREFIX .. key, value )
end

function ENTITY:getDevEntity( key, value )
	return self:GetNW2Entity( PREFIX .. key, value )
end

function ENTITY:setDevEntity( key, value )
	return self:SetNW2Entity( PREFIX .. key, value )
end

function ENTITY:getDevInt( key, fallbackValue )
	return self:GetNW2Int( PREFIX .. key, fallbackValue )
end

function ENTITY:setDevBool( key, value )
	return self:SetNW2Bool( PREFIX .. key, value )
end

function ENTITY:getDevBool( key, fallbackValue )
	return self:GetNW2Bool( PREFIX .. key, fallbackValue )
end

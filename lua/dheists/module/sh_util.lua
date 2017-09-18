--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

function dHeists.isPolice( player )
    return dHeists.config.isPoliceFunction( player )
end

-- Vector tostring changes
local VECTOR = FindMetaTable( "Vector" )

local roundNum = math.Round
function VECTOR:__tostring()
    return "Vector( " .. roundNum( self.x ) .. ", " .. roundNum( self.y ) .. ", " .. roundNum( self.z ) .. " )"
end

-- Angle tostring changes
local ANGLE = FindMetaTable( "Angle" )

local roundNum = math.Round
function ANGLE:__tostring()
    return "Angle( " .. roundNum( self.p ) .. ", " .. roundNum( self.y ) .. ", " .. roundNum( self.r ) .. " )"
end

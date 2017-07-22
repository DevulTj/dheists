--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local function attachCurrency( str )
    return ( dHeists.config.currency or "$" ) .. str
end

function dHeists.formatMoney( amount )
    if not amount then return attachCurrency( "0" ) end

    if amount >= 1e14 then return attachCurrency( tostring( amount ) ) end
    if amount <= -1e14 then return "-" .. attachCurrency( tostring( math.abs( amount ) ) ) end

    local negative = amount < 0

    amount = tostring( math.abs( amount ) )
    local sep = sep or ","
    local dp = string.find( amount, "%." ) or #amount + 1

    for i = dp - 4, 1, -3 do
        amount = amount:sub( 1, i ) .. sep .. amount:sub( i + 1 )
    end

    return ( negative and "-" or "" ) .. attachCurrency( amount )
end

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

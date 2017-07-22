--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

local PLAYER = FindMetaTable( "Player" )

function PLAYER:getBag()
    return self._dHeistsBag
end

function PLAYER:setBag( entity )
    return dHeists.setBag( self, entity )
end

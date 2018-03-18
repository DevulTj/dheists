--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

local PLAYER = FindMetaTable( "Player" )

function PLAYER:getBag()
    return self._dHeistsBag
end

function PLAYER:setBag( entity )
    return dHeists.setBag( self, entity )
end

function PLAYER:addLoot( lootName )
    local bag = self:getBag()
    if not bag then return false end
    if #bag.lootItems >= bag.capacity then return false end

    table.insert( self._dHeistsBag.lootItems, lootName )

    net.Start( "dHeists.sendBagItems" )
        net.WriteTable( self._dHeistsBag.lootItems )
    net.Send( self )

    hook.Run( "dHeists.onAddLoot", self, lootName, bag )

    return true
end
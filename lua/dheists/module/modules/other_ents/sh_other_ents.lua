--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

dHeists.ent.list = {}
dHeists.ent.locations = {}

function dHeists.ent.create( name, data )
    local ent = data
    data.name = name

    dHeists.ent.list[ name ] = ent
end

function dHeists.ent.addLocation( map, name, data )
    local location = data
    location.name = name

    dHeists.ent.locations[ map ] = dHeists.ent.locations[ map ] or {}
    dHeists.ent.locations[ map ][ name ] = location
end

function dHeists.ent.getEntLocations( name )
    local curLevel = game.GetMap()
    return dHeists.ent.locations[ curLevel ] and dHeists.ent.locations[ curLevel ][ name ]
end

hook.Call( "dHeists.ent.registerEnts" )

-- Include configuration for ents
frile.includeFile( "dheists/config/config_entities/sh_other_ents.lua" )

-- Property
properties.Add( "saveOtherEntity", {
	MenuLabel = "[dHeists] Save Entity",
	Order = 0,
	MenuIcon = "icon16/shield.png",

    Filter = function( self, entity, ply )
        if not entity.IsDHeistsEnt then return end
		if not ply:IsAdmin() or not entity:getDevBool( "notSaved", false ) then return false end
		--if not gamemode.Call( "CanProperty", ply, "saveOtherEntity", entity ) then return false end

		return true
	end,
	Action = function( self, entity ) -- CLIENT
        self:MsgStart()
            net.WriteEntity( entity )
        self:MsgEnd()
	end,
	Receive = function( self, length, player ) -- SERVER
		local entity = net.ReadEntity()
		if not self:Filter( entity, player ) then return end


        dHeists.db.insertOtherEntity( entity, function( data, lastInsert )
            entity:setDevInt( "creationId", lastInsert )
            entity:setDevBool( "notSaved", false )

            if IsValid( player ) then
                player:dHeistsHint( dL "entity_saved", NOTIFY_SUCCESS )
            end
        end )
	end
} )

properties.Add( "deleteOtherEntity", {
	MenuLabel = "[dHeists] Delete Entity",
	Order = 0,
	MenuIcon = "icon16/delete.png",

	Filter = function( self, entity, ply )
        if not entity.IsDHeistsEnt then return end
		if not ply:IsAdmin() or entity:getDevInt( "creationId", 0 ) == 0 then return false end
		--if not gamemode.Call( "CanProperty", ply, "deleteOtherEntity", entity ) then return false end

		return true
	end,
	Action = function( self, entity ) -- CLIENT
        self:MsgStart()
            net.WriteEntity( entity )
        self:MsgEnd()
	end,
	Receive = function( self, length, player ) -- SERVER
		local entity = net.ReadEntity()
		if not self:Filter( entity, player ) then return end

        dHeists.db.deleteOtherEntity( entity:getDevInt( "creationId" ), function()
            SafeRemoveEntity( entity )

            if IsValid( player ) then
                player:dHeistsHint( dL "entity_deleted", NOTIFY_SUCCESS )
            end
        end )
	end
} )

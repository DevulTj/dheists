
--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

properties.Add( "removeFromZone", {
	MenuLabel = "[dHeists] Delete from Zone",
	Order = 0,
	MenuIcon = "icon16/delete.png",

	Filter = function( self, entity, ply )
		if not entity._Entity then return end

		if not ply:IsAdmin() or entity:getDevInt( "creationId", 0 ) == 0 then return false end
		--if not gamemode.Call( "CanProperty", ply, "removeFromZone", entity ) then return false end

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

        if not entity._Entity then return end

        local zone = entity.getZone and entity:getZone()
        if not zone then return end

        dHeists.zones:deleteEntityFromZone( zone:getName(), entity )

        SafeRemoveEntity( entity )
	end
} )
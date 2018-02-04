--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

function dHeists.isPolice( player )
	return dHeists.config.isPoliceFunction( player )
end

local WHITELIST = {
	[ "dheists_rob_ent_base" ] = true,
	[ "dheists_cctv_tv_base" ] = true,
	[ "dheists_cctv_camera_base" ] = true,
	[ "dheists_alarm_base" ] = true
}

local RETURN_FUNCS = {
	[ "dheists_rob_ent_base" ] = function( ent ) return ent.GetEntityType and dHeists.robbing.getEnt( ent:GetEntityType() ) and dHeists.robbing.getEnt( ent:GetEntityType() ).name or ent:GetClass() end,
}

concommand.Add( "dheists_ent_export", function( player )
	local entities = ents.FindInSphere( player:GetPos(), 512 )

	local rnd = function( n )
		return math.Round( n )
	end

	local myStr = ""
	local function addEnt( ent, class, pos, ang )
		myStr = myStr .. "\n" .. [[{
	type = "${className}",
	pos = Vector( ${posX}, ${posY}, ${posZ} ),
	ang = Angle( ${angP}, ${angY}, ${angR} ),
},]] 	% {
			className = RETURN_FUNCS[ class ] and RETURN_FUNCS[ class ]( ent ) or class,
			posX = rnd( pos.x ), posY = rnd( pos.y ), posZ = rnd( pos.z ),
			angP = rnd( ang.p ), angY = rnd( ang.y ), angR = rnd( ang.r )
		}
	end

	for k, v in pairs( entities ) do
		local class = v:GetClass()
		if WHITELIST[ v:GetClass() ] then
			addEnt( v, class, v:GetPos(), v:GetAngles() )
		end
	end

	print( myStr )
end )
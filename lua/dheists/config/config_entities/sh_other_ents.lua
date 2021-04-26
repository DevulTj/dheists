--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

--[[
    Don't touch this if you don't know what you're doing.
]]
dHeists.ent.create( "Loot Trigger", {
    model = "models/hunter/tubes/circle4x4.mdl",
    noDisplay = true,

    startTouch = function( self, entity )
        if entity:IsPlayer() then
            local bag = entity:getBag()
            if not bag then return end

            dHeists.collectBag( self, entity )
        end
    end,
    onSpawn = function( self )
        dHeists.lootTrigger = self
    end
} )

dHeists.ent.addLocation( "gm_construct", "Loot Trigger", {
    pos = Vector( 1093, 271, -79 ),
    ang = Angle( 0, 135, 0 ),
} )

dHeists.ent.addLocation( "gm_flatgrass", "Loot Trigger", {
    pos = Vector( -580, -34, -12223 ),
    ang = Angle( 0, 135, 0 ),
} )

dHeists.ent.addLocation( "rp_florida", "Loot Trigger", {
    pos = Vector( 356, -6719, 200 ),
    ang = Angle( 0, 0, 0 ),
} )

dHeists.ent.addLocation( "rp_downtown_v4c_v4_sewers", "Loot Trigger", {
    pos = Vector( 2991, 551, -131 ),
    ang = Angle( 0, 0, 0 ),
} )

dHeists.ent.addLocation( "rp_rockford_mrp_v1b", "Loot Trigger", {
    pos = {
        Vector( -3614, -8034, 64 ),
        Vector( 3062, 165, 625 )
    },
    rotationTime = 900,
    ang = {
        Angle( 0, 45, 0 ),
        Angle( 0, 0, 0 ),
    }
} )

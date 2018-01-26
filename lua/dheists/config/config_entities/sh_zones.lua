--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.zones:registerZone( "gm_flatgrass", "The cool bank", {
    origin = Vector( 49, -161, -12287 ),
    mins = Vector( -300, -300, 0 ),
    maxs = Vector( 300, 300, 100 ),

    objects = {
        {
            type = "Small Vault",
            pos = Vector( -200, -126, -12287 ),
            ang = Angle( 0, 90, 0 )
        }
    }
} )

dHeists.zones:registerZone( "gm_construct", "Construct Bank Inc.", {
    origin = Vector( -33, -323, -83 ),
    mins = Vector( -300, -300, -50 ),
    maxs = Vector( 300, 300, 10 ),

    objects = {
        {
            type = "Small Vault",
            pos = Vector( 29, -129, -83 ),
            ang = Angle( 0, 90, 0 )
        }
    }
} )
--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.zones = dHeists.zones or {}
dHeists.zones.list = {}

hook.Add( "dHeists.zones.registerZones", dHeists.IDENTIFIER, function()

-- DO NOT EDIT ANYTHING ABOVE THIS LINE!

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

-- DO NOT EDIT ANYTHING BELOW THIS LINE!

end )

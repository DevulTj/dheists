--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.zones = dHeists.zones or {}
dHeists.zones.list = {}

hook.Add( "dHeists.zones.registerZones", dHeists.IDENTIFIER, function()

-- DO NOT EDIT ANYTHING ABOVE THIS LINE!

dHeists.zones:registerZone( "Zone", {
    mins = Vector( -363, 368, -12223 ),
    maxs = Vector( -25, -167, -12052 ),

    objects = {
        {
            type = "Small Vault",
            pos = Vector( -200, -126, -12150 ),
            ang = Angle( 0, 90, 0 )
        }
    }
} )

-- DO NOT EDIT ANYTHING BELOW THIS LINE!

end )

--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]


hook.Add( "dHeists.masks.registerMasks", dHeists.IDENTIFIER, function()

-- DO NOT EDIT ANYTHING ABOVE THIS LINE!

dHeists.LOOT_CASH_ROLL_SMALL = dHeists.masks:registerMask( "Dallas Mask", {
    model = "models/shaklin/payday2/masks/pd2_mask_dallas.mdl",
    pos = Vector( 1, 0, -3 ),
    ang = Angle( 90, 180, 90 )
} )

-- DO NOT EDIT ANYTHING BELOW THIS LINE!

end )

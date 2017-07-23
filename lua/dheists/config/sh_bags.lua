--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]


hook.Add( "dHeists.bags.registerBag", dHeists.IDENTIFIER, function()

-- DO NOT EDIT ANYTHING ABOVE THIS LINE!

dHeists.BAG_REGULAR = dHeists.bags.registerBag( "Regular Bag", {
    bagType = 1,
    skin = 0,
    capacity = 4
} )

dHeists.BAG_LUXURY = dHeists.bags.registerBag( "Luxury Bag", {
    bagType = 2,
    skin = 1,
    capacity = 8
} )

dHeists.BAG_LUXURY = dHeists.bags.registerBag( "Enhanced Bag", {
    bagType = 3,
    skin = 2,
    capacity = 12
} )

-- DO NOT EDIT ANYTHING BELOW THIS LINE!

end )

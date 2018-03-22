--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

dHeists.BAG_REGULAR = dHeists.bags.registerBag( "bag_regular", {
    bagType = 1,
    skin = 0,
    capacity = 2,

    worth = 2500,
    level = 25
} )

dHeists.BAG_LUXURY = dHeists.bags.registerBag( "bag_luxury", {
    bagType = 2,
    skin = 1,
    capacity = 4,

    level = 50,
    worth = 5000
} )

dHeists.BAG_ENHANCED = dHeists.bags.registerBag( "bag_enhanced", {
    bagType = 3,
    skin = 2,
    capacity = 6,

    level = 75,
    worth = 10000
} )

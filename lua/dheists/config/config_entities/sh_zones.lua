--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

-- dHeists.zones:registerZone( "gm_flatgrass", "The cool bank", {
--     origin = Vector( 49, -161, -12287 ),

--     objects = {
--         {
--             type = "Small Vault",
--             pos = Vector( -200, -126, -12287 ),
--             ang = Angle( 0, 90, 0 )
--         }
--     }
-- } )

-- dHeists.zones:registerZone( "rp_downtown_v4c_v4_sewers", "Parker Warehouse", {
--     origin = Vector( -1976, 670, -131 ),

--     objects = {
--         {
--             type = "Small Vault",
--             pos = Vector( -1954, 927, -196 ),
--             ang = Angle( 0, -90, 0 ),
--         },
--         {
--             type = "Small Vault",
--             pos = Vector( -2078, 927, -196 ),
--             ang = Angle( 0, -90, 0 ),
--         },
--         {
--             type = "Small Vault",
--             pos = Vector( -2200, 927, -195 ),
--             ang = Angle( 0, -90, 0 ),
--         }
--     },

--     screens = {
--         {
--             pos = Vector( -1432, 475, -71 ),
--             ang = Angle( 90, 180, 180 ),
--         }
--     },

--     tvs = {
--         {
--             type = "dheists_cctv_tv_base",
--             pos = Vector( -1864, 480, -161 ),
--             ang = Angle( 0, 90, 0 ),
--         },
--     },
--     cameras = {
--         {
--             type = "dheists_cctv_camera_base",
--             pos = Vector( -1450, 416, -69 ),
--             ang = Angle( -3, 90, 0 ),
--         },
--     }
-- } )

-- dHeists.zones:registerZone( "gm_construct", "Construct Bank Inc.", {
--     origin = Vector( -33, -323, -83 ),

--     objects = {
--         {
--             type = "Small Vault",
--             pos = Vector( 29, -129, -83 ),
--             ang = Angle( 0, 90, 0 )
--         }
--     }
-- } )

-- dHeists.zones:registerZone( "rp_florida", "Bank of Florida", {
--     origin = Vector(  1276, -6720, 200 ),

--     objects = {
--         {
--             type = "Small Vault",
--             pos = Vector( 1366, -6653, 136 ),
--             ang = Angle( 0, -180, 0 )
--         }
--     },

--     alarms = {
--         {
--             type = "dheists_alarm_base",
--             pos = Vector( 1125, -6652, 265 ),
--             ang = Angle( 90, 0, 180 )
--         },
--         {
--             type = "dheists_alarm_base",
--             pos = Vector( 1125, -6790, 265 ),
--             ang = Angle( 90, 0, 180 )
--         },
--     },

--     cameras = {
--         {
--             type = "dheists_cctv_camera_base",
--             pos = Vector( 1116, -6480, 268 ),
--             ang = Angle( 0, -180, 0 )
--         },
--         {
--             type = "dheists_cctv_camera_base",
--             pos = Vector( 1391, -6825, 269 ),
--             ang = Angle( 0, 90, 0 )
--         }
--     },

--     tvs = {
--         {
--             pos = Vector( 946, -6500, 170 ),
--             ang = Angle( 0, -60, 0 )
--         }
--     },

--     tripwires = {
--         {
--             pos = Vector( 1228, -6608, 150 ),
--             ang = Angle( 45, 180, -90 )
--         }
--     }
-- } )

-- dHeists.zones:registerZone( "rp_rockford_mrp_v1b", "Shell Gas Station", {
--     origin = Vector( 1237, 3753, 608 ),

--     alarmDuration = 180,

--     jobCategories = {
--         [ "Police" ] = true
--     },

--     minJobOnlineForRobbery = 3,

--     objects = {
--         {
--             type = "Small Vault",
--             pos = Vector( 1343, 3780, 544 ),
--             ang = Angle( 0, 180, 0 ),
--         },
--         {
--             type = "Item Crate",
--             pos = Vector( 1352, 3671, 569 ),
--             ang = Angle( 0, -180, 0 ),
--         },
--         {
--             type = "Item Crate",
--             pos = Vector( 1353, 3704, 544 ),
--             ang = Angle( 0, 180, 0 ),
--         },
--         {
--             type = "Item Crate",
--             pos = Vector( 1338, 3671, 544 ),
--             ang = Angle( 0, 180, 0 ),
--         }
--     },

--     alarms = {
--         {
--             type = "dheists_alarm_base",
--             pos = Vector( 630, 4010, 665 ),
--             ang = Angle( 38, 90, -90 ),
--         },
--         {
--             type = "dheists_alarm_base",
--             pos = Vector( 630, 3861, 665 ),
--             ang = Angle( 38, 90, -90 ),
--         },
--         {
--             type = "dheists_alarm_base",
--             pos = Vector( 1122, 3711, 678 ),
--             ang = Angle( 0, 180, 180 ),
--         }
--     }
-- } )

-- dHeists.zones:registerZone( "rp_rockford_mrp_v1b", "Bank of Rockford", {
--     origin = Vector( -3995, -3879, 110 ),

--     alarmSound =  "ambient/alarms/city_firebell_loop1.wav",
--     alarmDuration = 180,

--     jobCategories = {
--         [ "Police" ] = true,
--         [ "Bank Security" ] = true
--     },

--     minJobOnlineForRobbery = 6,

--     objects = {
--         {
--             type = "Safety Deposit Box",
--             pos = Vector( -4097, -4158, 68 ),
--             ang = Angle( 0, -90, 0 ),
--         },
--         {
--             type = "Safety Deposit Box",
--             pos = Vector( -4109, -4330, 68 ),
--             ang = Angle( 0, 90, 0 ),
--         },
--         {
--             type = "Small Vault",
--             pos = Vector( -3754, -4244, 68 ),
--             ang = Angle( 0, 180, 0 ),
--         },
--         {
--             type = "Small Vault",
--             pos = Vector( -3880, -4292, 68 ),
--             ang = Angle( 0, 90, 0 ),
--         },
--         {
--             type = "Safety Deposit Box",
--             pos = Vector( -4234, -4209, 68 ),
--             ang = Angle( 0, 0, 0 ),
--         },
--         {
--             type = "Safety Deposit Box",
--             pos = Vector( -4234, -4278, 68 ),
--             ang = Angle( 0, 0, 0 ),
--         },
--         {
--             type = "Safety Deposit Box",
--             pos = Vector( -4178, -4158, 68 ),
--             ang = Angle( 0, -90, 0 ),
--         },
--         {
--             type = "Safety Deposit Box",
--             pos = Vector( -4189, -4329, 68 ),
--             ang = Angle( 0, 90, 0 ),
--         },
--         {
--             type = "Small Vault",
--             pos = Vector( -4037, -4318, 68 ),
--             ang = Angle( 0, 89, 0 ),
--         }
--     },

--     cameras = {
--         {
--             name = "Main Vault #1",
--             type = "dheists_cctv_camera_base",
--             pos = Vector( -4227, -4343, 268 ),
--             ang = Angle( 0, 0, 0 )
--         },
--         {
--             name = "Main Vault #2",
--             type = "dheists_cctv_camera_base",
--             pos = Vector( -3742, -4144, 272 ),
--             ang = Angle( 0, 180, 0 ),
--         },
--         {
--             name = "Vault Entrance #1",
--             type = "dheists_cctv_camera_base",
--             pos = Vector( -3720, -3993, 260 ),
--             ang = Angle( 0, 90, 0 )
--         },
--         {
--             name = "Vault Entrance #2",
--             type = "dheists_cctv_camera_base",
--             pos = Vector( -4247, -3403, 275 ),
--             ang = Angle( 0, -90, 0 )
--         },
--         {
--             name = "Main Bank",
--             type = "dheists_cctv_camera_base",
--             pos = Vector( -3886, -3319, 171 ),
--             ang = Angle( 0, 0, 0 ),
--         }
--     },

--     alarms = {
--         {
--             type = "dheists_alarm_base",
--             pos = Vector( -3879, -4153, 221 ),
--             ang = Angle( 45, -180, -90 )
--         },
--         {
--             type = "dheists_alarm_base",
--             pos = Vector( -3810, -3310, 167 ),
--             ang = Angle( 90, -90, 180 )
--         },
--         {
--             type = "dheists_alarm_base",
--             pos = Vector( -2758, -2955, 157 ),
--             ang = Angle( 45, 135, 90 )
--         },
--         {
--             type = "dheists_alarm_base",
--             pos = Vector( -2957, -2756, 156 ),
--             ang = Angle( 45, 135, 90 )
--         },
--     },

--     tvs = {
--         {
--             pos = Vector( -8115, -4956, 45 ),
--             ang = Angle( 0, -90, 0 )
--         }
--     },

--     alarmButtons = {
--         {
--             pos = Vector( -8170, -4956, 40 ),
--             ang = Angle( 0, -90, 0 )
--         }
--     },

--     tripwires = {
--         {
--             pos = Vector( -3817, -4151, 122 ),
--             ang = Angle( 78, 5, -174 )
--         }
--     },

--     screens = {
--         {
--             pos = Vector( -3808, -3319, 132 ),
--             ang = Angle( 90, -90, 180 )
--         }
--     }
-- } )

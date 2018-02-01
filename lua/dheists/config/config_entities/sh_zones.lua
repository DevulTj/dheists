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

dHeists.zones:registerZone( "rp_florida", "Bank of Florida", {
    origin = Vector(  1276, -6720, 200 ),
    mins = Vector( -100, -100, -64 ),
    maxs = Vector( 100, 100, 70 ),

    objects = {
        {
            type = "Small Vault",
            pos = Vector( 1366, -6653, 136 ),
            ang = Angle( 0, -180, 0 )
        }
    },

    alarms = {
        {
            type = "dheists_alarm_base",
            pos = Vector( 1125, -6652, 265 ),
            ang = Angle( 90, 0, 180 )
        },
        {
            type = "dheists_alarm_base",
            pos = Vector( 1125, -6790, 265 ),
            ang = Angle( 90, 0, 180 )
        },
    },

    cameras = {
        {
            type = "dheists_cctv_camera_base",
            pos = Vector( 1116, -6480, 268 ),
            ang = Angle( 0, -180, 0 )
        },
        {
            type = "dheists_cctv_camera_base",
            pos = Vector( 1391, -6825, 269 ),
            ang = Angle( 0, 90, 0 )
        }
    },

    tvs = {
        {
            pos = Vector( 946, -6500, 170 ),
            ang = Angle( 0, -60, 0 )
        }
    },

    tripwires = {
        {
            pos = Vector( 1228, -6608, 150 ),
            ang = Angle( 45, 180, -90 )
        }
    }
} )

dHeists.zones:registerZone( "rp_rockford_mrp_v1b", "Warehouse #1", {
    origin = Vector( -7992, 3791, 64 ),
    mins = Vector( -890, -390, -64 ),
    maxs = Vector( 880, 290, 70 ),

    objects = {
        {
            type = "Item Crate",
            pos = Vector( -7937, 3415, 26 ),
            ang = Angle( 0, 90, 0 )
        },
        {
            type = "Item Crate",
            pos = Vector( -8021, 3415, 58 ),
            ang = Angle( 0, 90, 0 )
        },
        {
            type = "Item Crate",
            pos = Vector( -8064, 3415, 0 ),
            ang = Angle( 0, 90, 0 )
        },
        {
            type = "Item Crate",
            pos = Vector( -8109, 3415, 0 ),
            ang = Angle( 0, 90, 0 )
        },
    }
} )
dHeists.zones:registerZone( "rp_rockford_mrp_v1b", "Bank of Rockford", {
    origin = Vector( -3995, -3879, 110 ),
    mins = Vector( -890, -390, -64 ),
    maxs = Vector( 880, 290, 70 ),

    alarmSound =  "ambient/alarms/city_firebell_loop1.wav",
    alarmDuration = 600,

    objects = {
        {
            type = "Small Vault",
            pos = Vector( -3754, -4244, 68 ),
            ang = Angle( 0, 180, 0 )
        },
        {
            type = "Small Vault",
            pos = Vector( -3880, -4292, 68 ),
            ang = Angle( 0, 90, 0 )
        },
        {
            type = "Safety Deposit Box",
            pos = Vector( -4234, -4209, 68 ),
            ang = Angle( 0, 0, 0 ),
        },
        {
            type = "Safety Deposit Box",
            pos = Vector( -4234, -4278, 68 ),
            ang = Angle( 0, 0, 0 ),
        },
        {
            type = "Safety Deposit Box",
            pos = Vector( -4178, -4158, 68 ),
            ang = Angle( 0, -90, 0 ),
        },
        {
            type = "Safety Deposit Box",
            pos = Vector( -4189, -4329, 68 ),
            ang = Angle( 0, 90, 0 ),
        },

    },

    cameras = {
        {
            name = "Main Vault",
            type = "dheists_cctv_camera_base",
            pos = Vector( -4227, -4343, 268 ),
            ang = Angle( 0, 0, 0 )
        },
        {
            name = "Vault Entrance #1",
            type = "dheists_cctv_camera_base",
            pos = Vector( -3720, -3993, 260 ),
            ang = Angle( 0, 90, 0 )
        },
        {   
            name = "Vault Entrance #2",
            type = "dheists_cctv_camera_base",
            pos = Vector( -4247, -3403, 275 ),
            ang = Angle( 0, -90, 0 )
        },
    },

    alarms = {
        {
            type = "dheists_alarm_base",
            pos = Vector( -3879, -4153, 221 ),
            ang = Angle( 45, -180, -90 )
        },
        {
            type = "dheists_alarm_base",
            pos = Vector( -3810, -3310, 167 ),
            ang = Angle( 90, -90, 180 )
        },
        {
            type = "dheists_alarm_base",
            pos = Vector( -2758, -2955, 157 ),
            ang = Angle( 45, 135, 90 )
        },
        {
            type = "dheists_alarm_base",
            pos = Vector( -2957, -2756, 156 ),
            ang = Angle( 45, 135, 90 )
        },
    },

    tvs = {
        {
            pos = Vector( -8115, -4956, 42 ),
            ang = Angle( 0, -90, 0 )
        }
    },

    tripwires = {
        {
            pos = Vector( -3817, -4151, 122 ),
            ang = Angle( 78, 5, -174 )
        }
    },
} )

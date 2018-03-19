
local version = 1

if frutil and frutil.VERSION >= version then return end

frutil = {
    VERSION = version,
    AUTHOR = "fruitwasp",
    AUTHOR_URL = "https://steamcommunity.com/id/fruitwasp"
}

local VECTOR = FindMetaTable( "Vector" )

function VECTOR:ceil()
    self.x = math.ceil( self.x )
    self.y = math.ceil( self.y )
    self.z = math.ceil( self.z )

    return self
end

local ANGLE = FindMetaTable( "Angle" )

function ANGLE:round( decimals )
    self.pitch = math.Round( self.pitch, decimals )
    self.yaw = math.Round( self.yaw, decimals )
    self.roll = math.Round( self.roll, decimals )

    return self
end

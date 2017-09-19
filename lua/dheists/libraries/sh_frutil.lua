local VECTOR = FindMetaTable( "Vector" )

function VECTOR:ceil()
    self.x = math.ceil( self.x )
    self.y = math.ceil( self.y )
    self.z = math.ceil( self.z )

    return self
end

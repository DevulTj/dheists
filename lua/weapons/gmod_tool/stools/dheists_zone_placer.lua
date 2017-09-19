
TOOL.Category = "dHeists"
TOOL.Name = "Zone Placer"

TOOL.ClientConVar[ "origin" ] = "0 0 0"
TOOL.ClientConVar[ "mins" ] = "0 0 0"
TOOL.ClientConVar[ "maxs" ] = "0 0 0"
TOOL.ClientConVar[ "z" ] = 100

TOOL.Information = {
    { name = "left" },
    { name = "right" }
}

TOOL.VECTOR_ZERO = Vector()
TOOL.ANGLE_ZERO = Angle()
TOOL.SHAPE_COLOR = color_white

function TOOL:LeftClick( trace )
    if CLIENT then
        self.currentStage = ( self.currentStage or -1 ) + 1

        if self.currentStage % 2 == 0 then
            self:SetConVar( "mins", tostring( trace.HitPos:ceil() ) )
        else
            self.maxs = trace.HitPos:ceil()
            self.maxs.z = self.maxs.z + self:GetClientInfo( "z" )

            self.maxs = self.maxs - Vector( self:GetClientInfo( "mins" ) )

            self:SetConVar( "maxs", tostring( self.maxs ) )

            self:drawBox()
        end
    end

    return true
end

function TOOL:drawBox()
    hook.Add( "PostDrawOpaqueRenderables", "zonePlacer", function()
        local mins, maxs =
            Vector( self:GetClientInfo( "mins" ) ),
            Vector( self:GetClientInfo( "maxs" ) )

        render.DrawWireframeBox( mins, self.ANGLE_ZERO, self.VECTOR_ZERO, maxs, self.SHAPE_COLOR, true )
    end )
end

function TOOL:RightClick( trace )
    self:Holster()

    return true
end

function TOOL:Reload()
    self:Holster()

    return true
end

function TOOL:Holster()
    if CLIENT then
        self.currentStage = -1
        hook.Remove( "PostDrawOpaqueRenderables", "zonePlacer" )
    end
end

function TOOL:SetConVar( key, value )
    RunConsoleCommand( "dheists_zone_placer_" .. key, value )
end

function TOOL:BuildCPanel()
    self:AddControl( "Slider", {
        Label = "Height of the box",
        Command = "dheists_zone_placer_z",
        Min = -1000,
        Max = 1000
    } )
end

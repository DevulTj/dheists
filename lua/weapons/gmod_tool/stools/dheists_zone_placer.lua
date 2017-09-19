
TOOL.Category = "dHeists"
TOOL.Name = "Zone Placer"

TOOL.ClientConVar[ "origin_x" ] = 0
TOOL.ClientConVar[ "origin_y" ] = 0
TOOL.ClientConVar[ "origin_z" ] = 0
TOOL.ClientConVar[ "depth_x" ] = 100
TOOL.ClientConVar[ "depth_y" ] = 100
TOOL.ClientConVar[ "depth_z" ] = 100

TOOL.Information = {
    { name = "left" },
    { name = "right" }
}

TOOL.VECTOR_ZERO = Vector()
TOOL.ANGLE_ZERO = Angle()
TOOL.SHAPE_COLOR = color_white

function TOOL:LeftClick( trace )
    if CLIENT then
        local origin = trace.HitPos

        RunConsoleCommand( "dheists_zone_placer_origin_x", math.ceil( origin.x ) )
        RunConsoleCommand( "dheists_zone_placer_origin_y", math.ceil( origin.y ) )
        RunConsoleCommand( "dheists_zone_placer_origin_z", math.ceil( origin.z ) )

        hook.Add( "PostDrawOpaqueRenderables", "zonePlacer", function()
            local origin = Vector(
                self:GetClientInfo( "origin_x" ),
                self:GetClientInfo( "origin_y" ),
                self:GetClientInfo( "origin_z" )
            )

            local depth = Vector(
                self:GetClientInfo( "depth_x" ),
                self:GetClientInfo( "depth_y" ),
                self:GetClientInfo( "depth_z" )
            )

            render.DrawWireframeBox( origin, self.ANGLE_ZERO, self.VECTOR_ZERO, depth, self.SHAPE_COLOR, true )
        end )
    end

    return true
end

function TOOL:RightClick( trace )
    self:Holster()

    return true
end

function TOOL:Holster()
    if CLIENT then
        hook.Remove( "PostDrawOpaqueRenderables", "zonePlacer" )
    end
end

if CLIENT then
    function TOOL:BuildCPanel()
        self:AddControl( "Slider",  {
            Label	= "Depth on the x-axis",
            Type	= "Int",
            Min		= -1000,
            Max		= 1000,
            Command = "dheists_zone_placer_depth_x" })

        self:AddControl( "Slider",  {
            Label	= "Depth on the y-axis",
            Type	= "Int",
            Min		= -1000,
            Max		= 1000,
            Command = "dheists_zone_placer_depth_y" })

        self:AddControl( "Slider",  {
            Label	= "Depth on the z-axis",
            Type	= "Int",
            Min		= -1000,
            Max		= 1000,
            Command = "dheists_zone_placer_depth_z" })
    end
end

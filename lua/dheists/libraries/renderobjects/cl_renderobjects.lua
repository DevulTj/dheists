--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

renderObjects = renderObjects or {}
renderObjects.objectList = renderObjects.objectList or {}

net.Receive( "renderObjects.setObject", function()
    local player = Entity( net.ReadUInt( 16 ) )
    if not IsValid( player ) then return end

    renderObjects:setObject( player, net.ReadString() )
end )

net.Receive( "renderObjects.clearObject", function()
    local player = Entity( net.ReadUInt( 16 ) )
    if not IsValid( player ) then return end
    
    renderObjects:clearObject( player, net.ReadString() )
end )
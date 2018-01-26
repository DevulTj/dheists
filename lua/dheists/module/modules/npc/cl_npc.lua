--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

net.Receive( "dHeists_npcUse", function( len )
    local npcType = net.ReadString()
    local npcData = dHeists.npc.list[ npcType ]
    if not npcData then return end

    if npcData.useFunc then npcData.useFunc() end
end )

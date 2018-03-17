--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }}
]]

net.Receive( "dHeists_entUse", function( len )
    local entType = net.ReadString()
    local entData = dHeists.ent.list[ entType ]
    if not entData then return end

    if entData.useFunc then entData.useFunc() end
end )

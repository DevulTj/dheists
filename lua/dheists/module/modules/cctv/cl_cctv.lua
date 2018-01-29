--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

net.Receive( "dHeists_ViewCCTV", function( _ )
    local tvEntity = net.ReadEntity()
    local zoneId = tvEntity:GetZoneID()

    local frame = vgui.Create( "dHeists_CCTVFrame" )
    frame:Setup( zoneId )
end )
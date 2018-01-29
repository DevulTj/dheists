--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

dHeists.cctv = dHeists.cctv or {}

util.AddNetworkString( "dHeists_ViewCCTV" )

function dHeists.cctv.viewCCTV( player, entity )
    if player:GetPos():Distance( entity:GetPos() ) > 256 then return end
    
    net.Start( "dHeists_ViewCCTV" ) 
        net.WriteEntity( entity )
    net.Send( player )
end
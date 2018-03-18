--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

dHeists.cctv = dHeists.cctv or {}

util.AddNetworkString( "dHeists_ViewCCTV" )

function dHeists.cctv.viewCCTV( player, entity )
    if player:GetPos():Distance( entity:GetPos() ) > 256 then return end

    net.Start( "dHeists_ViewCCTV" ) 
        net.WriteEntity( entity )
    net.Send( player )

    player.ViewingCCTV = true
end

net.Receive( "dHeists_ViewCCTV", function( _, player )
    player.ViewingCCTV = nil
end )

hook.Add( "SetupPlayerVisibility", "dHeists_RenderCCTV", function( player )
	-- Adds any view entity
    if player.ViewingCCTV then
        for _, zone in pairs( dHeists.zones.zones ) do
            AddOriginToPVS( zone.origin )
        end
    end
end )
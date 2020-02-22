--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]


local PLAYER = FindMetaTable( "Player" )

function PLAYER:dHeists_isCarryingBag()
    return self:getDevBool( "isCarryingBag", false )
end
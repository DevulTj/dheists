--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

function dHeists.isPolice( player )
    return dHeists.config.isPoliceFunction( player )
end

getmetatable("").__mod = function(s, tab) return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end)) end

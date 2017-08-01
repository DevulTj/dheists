--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

surface.CreateFont( "dHeistsLarge", {
	font = dHeists.config.fontFace or "Purista",
	size = 32,
	weight = dHeists.config.fontWeight or 800,
	antialias = true
} )

surface.CreateFont( "dHeistsMedium", {
	font = dHeists.config.fontFace or "Purista",
	size = 24,
	weight = dHeists.config.fontWeight or 800,
	antialias = true
} )

surface.CreateFont( "dHeists_bagText", {
    font = dHeists.config.fontFace or "Purista",
    weight = 800,
    size = 26,
} )

surface.CreateFont( "dHeists_bagTextItalics", {
    font = dHeists.config.fontFace or "Purista",
	weight = 800,
	size = 20,
	italic = true,
	strikeout = true,
} )

surface.CreateFont( "dHeists_bagText3D", {
    font = dHeists.config.fontFace or "Purista",
    weight = 800,
    size = 32,
} )

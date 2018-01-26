--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

surface.CreateFont( "dHeistsMassive", {
	font = dHeists.config.fontFace or "Purista",
	size = 70,
	weight = dHeists.config.fontWeight or 800,
	antialias = true
} )

surface.CreateFont( "dHeistsHuge", {
	font = dHeists.config.fontFace or "Purista",
	size = 48,
	weight = dHeists.config.fontWeight or 800,
	antialias = true
} )

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

surface.CreateFont( "dHeistsSmall", {
	font = dHeists.config.fontFace or "Purista",
	size = 18,
	weight = ( dHeists.config.fontWeight or 800 ) / 2,
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

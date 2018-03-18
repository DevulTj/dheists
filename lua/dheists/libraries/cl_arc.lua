--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

local cos, sin, abs, max, rad1, log, pow = math.cos, math.sin, math.abs, math.max, math.rad, math.log, math.pow
local surface = surface
function draw.Arc(cx,cy,radius,thickness,startang,endang,roughness,color)
	surface.SetDrawColor(color)
	surface.DrawArc(surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness))
end

function surface.DrawArc(arc) -- Draw a premade arc.
	for k,v in ipairs(arc) do
		surface.DrawPoly(v)
	end
end

function surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness)
	local quadarc = {}

	-- Correct start/end ang
	local startang,endang = startang or 0, endang or 0

	-- Define step
	-- roughness = roughness or 1
	local diff = abs(startang-endang)
	local smoothness = log(diff,2)/2
	local step = diff / (pow(2,smoothness))
	if startang > endang then
		step = abs(step) * -1
	end

	-- Create the inner circle's points.
	local inner = {}
	local outer = {}
	local ct = 1
	local r = radius - thickness

	for deg=startang, endang, step do
		local rad = rad1(deg)
		-- local rad = deg2rad * deg
		local cosrad, sinrad = cos(rad), sin(rad) --calculate sin,cos

		local ox, oy = cx+(cosrad*r), cy+(-sinrad*r) --apply to inner distance
		inner[ct] = {
			x=ox,
			y=oy,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		}

		local ox2, oy2 = cx+(cosrad*radius), cy+(-sinrad*radius) --apply to outer distance
		outer[ct] = {
			x=ox2,
			y=oy2,
			u=(ox2-cx)/radius + .5,
			v=(oy2-cy)/radius + .5,
		}

		ct = ct + 1
	end

	-- QUAD the points.
	for tri=1,ct do
		local p1,p2,p3,p4
		local t = tri+1
		p1=outer[tri]
		p2=outer[t]
		p3=inner[t]
		p4=inner[tri]

		quadarc[tri] = {p1,p2,p3,p4}
	end

	-- Return a table of triangles to draw.
	return quadarc

end

function draw.DrawPercRect(x, y, w, h, perc, sten)
	local d
	local rx, ry
	local px, py

	if (sten) then
		w, h = w*2, h*2
		d = w/2
	else
		d = math.sqrt(w^2 + h^2)/2
	end

	px, py = math.sin(perc*math.pi*2), -math.cos(perc*math.pi*2)
	rx, ry = math.Clamp(x + px*d, x - w/2, x + w/2), math.Clamp(y + py*d, y - h/2, y + h/2)

	if (perc < .25) then
		triangle = {
			{ x = rx , y = ry },
			{ x = x + w/2, y = y - h/2 },
			{ x = x + w/2, y = y + 0 },
			{ x = x , y = y + 0 },
		}
		surface.DrawPoly( triangle )
	end

	if (perc < .5) then
		triangle = {
			{ x = x , y = y - 0 },
			{ x = x + w/2, y = y - 0 },
			{ x = x + w/2, y = y + h/2 },
			{ x = x , y = y + h/2 },
		}
		if (perc > .25) then
			triangle[2] = { x = rx , y = ry }
			if (perc > (.25 + .25/2)) then
				triangle[3] = { x = rx , y = ry }
			end
		end
		surface.DrawPoly( triangle)
	end

	if (perc < .75) then
		triangle = {
			{ x = x - w/2, y = y - 0 },
			{ x = x + 0, y = y - 0 },
			{ x = x + 0, y = y + h/2 },
			{ x = x - w/2, y = y + h/2 },
		}
		if (perc > .5) then
			triangle[3] = { x = rx , y = ry }
		end
		surface.DrawPoly( triangle )
	end

	triangle = {
		{ x = x - w/2, y = y - h/2 },
		{ x = x + 0, y = y - h/2 },
		{ x = x + 0, y = y + 0 },
		{ x = x - w/2, y = y + 0 },
	}
	if (perc > .75) then
		triangle[4] = { x = rx , y = ry }
		if (perc > (.75 + .25/2)) then
			triangle[1] = { x = rx , y = ry }
		end
	end
	surface.DrawPoly( triangle )
end

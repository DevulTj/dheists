--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

AddCSLuaFile()

ENT.Name = "Base Entity"
ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.Author = "DevulTj"
ENT.Category = "dHeists"
ENT.AutomaticFrameAdvance = false

ENT.IsDHeistsEnt = true
ENT.DHeists = true

ENT.physicsBox = {
    mins = Vector( -7, -10, -0 ),
    maxs = Vector( 7, 10, 75 )
}

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "EntType" )
end

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )
		if not tr.Hit then return end

		local SpawnPos = tr.HitPos + tr.HitNormal * 16

		local ent = ents.Create( ClassName )
		ent:SetPos( SpawnPos )
		ent:setDevEntity( "creator", ply )
		ent:Spawn()
		ent:Activate()

		return ent
	end

	function ENT:Initialize()
		self:SetModel( "models/gman_high.mdl" )
		self:SetHullType( HULL_HUMAN )
		self:SetHullSizeNormal()

        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )

		if self.SetMaxYawSpeed then self:SetMaxYawSpeed( 5000 ) end
		self:SetNotSolid( false )
		self:DropToFloor()

        self:SetTrigger( true )
        self:SetAutomaticFrameAdvance( false )
		
		self:DrawShadow( false )
	end

    function ENT:setEnt( entInfo )
        self:SetModel( entInfo.model )

		self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )

        self:GetPhysicsObject():EnableMotion( false )

        self.startTouch = entInfo.startTouch
        self:SetEntType( entInfo.name )

		self.entInfo = entInfo
    end

	function ENT:AcceptInput( name, activator, caller )
		if name ~= "Use" or not IsValid( caller ) or not caller:IsPlayer() then return end

		hook.Call( "dHeists_entUsed", nil, self, name, activator, caller )
	end

    function ENT:StartTouch( entity )
        if self.startTouch then self.startTouch( self, entity ) end
    end

	function ENT:EndTouch( entity )
        if self.endTouch then self.endTouch( self, entity ) end
	end

	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end

	function ENT:rotatePosition()
		-- Increment location ID
		self._currentRotationID = ( self._currentRotationID or 1 ) + 1

		-- If we exceed the length of the table, reset
		if self._currentRotationID > #self.pos then
			self._currentRotationID = 1
		end

		-- Update position
		self:SetPos( self.pos[ self._currentRotationID ] )

		-- Update angle if it exists
		if istable( self.ang ) then
			self:SetAngles( self.ang[ self._currentRotationID ] or self:GetAngles() )
		end

		self:DropToFloor()
	end
end

if CLIENT then
	-- Util functions
	local rad, sin, cos, max, floor, abs = math.rad, math.sin, math.cos, math.max, math.floor, math.abs

	function drawCircle(sx, sy, radius, vertexCount, color, angle)
	local vertices = {}
	local ang = -rad(angle or 0)
	local c = cos(ang)
	local s = sin(ang)
	for i = 0, 360, 360 / vertexCount do
		local radd = rad(i)
		local x = cos(radd)
		local y = sin(radd)

		local tempx = x * radius * c - y * radius * s + sx
		y = x * radius * s + y * radius * c + sy
		x = tempx

		vertices[#vertices + 1] = { x = x, y = y, u = u, v = v }
	end

	if vertices and #vertices > 0 then
		draw.NoTexture()
		surface.SetDrawColor(color)
		surface.DrawPoly(vertices)
	end
	end

	-- Thanks to Bobbleheadbob for the arc code, slightly modified to suit my needs.
	local function precacheArc(cx, cy, radius, thickness, startAng, endAng, vertexCount)
	local triarc = {}
	-- local deg2rad = math.pi / 180

	-- Define step
	local step = 360 / (vertexCount or 8)

	-- Correct start/end ang
	local startAng, endAng = startAng or 0, endAng or 0

	if startAng > endAng then
		step = abs(step) * -1
	end

	-- Create the inner circle's points.
	local inner = {}
	local r = radius - thickness
	for deg=startAng, endAng, step do
		local rad = -rad(deg)
		-- local rad = deg2rad * deg
		local ox, oy = cx + (cos(rad) * r), cy + (-sin(rad) * r)
		table.insert(inner, {
		x = ox,
		y = oy,
		u = (ox - cx) / radius + .5,
		v = (oy - cy) / radius + .5,
		})
	end


	-- Create the outer circle's points.
	local outer = {}
	for deg=startAng, endAng, step do
		local rad = -rad(deg)
		-- local rad = deg2rad * deg
		local ox, oy = cx + (cos(rad) * radius), cy + (-sin(rad) * radius)
		table.insert(outer, {
		x = ox,
		y = oy,
		u = (ox - cx) / radius + .5,
		v = (oy - cy) / radius + .5,
		})
	end

	-- Triangulize the points.
	for tri = 1, #inner * 2 do -- twice as many triangles as there are degrees.
		local p1, p2, p3
		p1 = outer[floor(tri / 2) + 1]
		p3 = inner[floor((tri + 1) / 2) + 1]
		if tri % 2 == 0 then --if the number is even use outer.
		p2 = outer[floor((tri + 1) / 2)]
		else
		p2 = inner[floor((tri + 1) / 2)]
		end

		table.insert(triarc, { p3, p2, p1 })
	end

	-- Return a table of triangles to draw.
	return triarc
	end

	-- Draws an arc on your screen.
	-- startAng and endAng are in degrees,
	-- radius is the total radius of the outside edge to the center.
	-- cx, cy are the x,y coordinates of the center of the arc.
	-- vertexCount determines how many triangles are drawn. Number between 1-360; 2 or 3 is a good number.
	function draw.DrawArc(cx, cy, radius, thickness, startAng, endAng, vertexCount, color)
		surface.SetDrawColor(color)
		local arc = precacheArc(cx, cy, radius, thickness, startAng, endAng, vertexCount)

		for k,v in ipairs(arc) do
			surface.DrawPoly(v)
		end
	end

	function ENT:Draw()
		if dHeists.config.debugEnabled then
			local boundMin, boundMax = self:GetCollisionBounds()
            render.DrawWireframeBox( self:GetPos(), self:GetAngles(), boundMin, boundMax, color_white )
        end

		if LocalPlayer():dHeists_isCarryingBag() then
			local eyeAng = EyeAngles()
			eyeAng.p = 0
			eyeAng.y = eyeAng.y - 90
			eyeAng.r = 90

			local printName = "Drop Off Point"
			local subTitleName = "Stay in the area to sell your goods."

			cam.Start3D2D(self:GetPos(), Angle(0, 180, 0), 0.2)
				draw.NoTexture()
				draw.DrawArc( 0, 0, 380, 30, 0, 360, 104, Color( 0, 0, 0, 100 ) )
				draw.DrawArc( 0, 0, 390, 30, 0, 360, 104, Color( 255, 155, 50 ) )
			cam.End3D2D()

			cam.Start3D2D(self:GetPos() + Vector(0,0,50) + ( self:GetAngles():Right() * 0 ), eyeAng, 0.2 )
				draw.SimpleText(printName, "dHeistsHuge", 6, 4, Color( 0, 0, 0, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText(printName,"dHeistsHuge", 4, 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				draw.SimpleText(subTitleName, "dHeists_bagTextLargeItalics", 6, 42, Color( 0, 0, 0, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText(subTitleName,"dHeists_bagTextLargeItalics", 4, 40, Color( 255, 155, 50 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			cam.End3D2D()
		end
	end

	local drawTextDistance = 160000
	hook.Add( "HUDPaint", "dHeists", function()
		local entity = LocalPlayer():GetEyeTrace().Entity
		if not IsValid( entity ) or not entity.IsDHeistsEnt or entity:GetPos():DistToSqr( LocalPlayer():GetPos() ) > drawTextDistance then return end

		local entData = dHeists.ent.list[ entity:GetEntType() ]
		if not entData then return end

		if entData.noDisplay then return end

		local pos = entity:GetPos()
		pos.z = pos.z + 59
		pos = pos:ToScreen()

		draw.SimpleText( entData.name, "dHeists_bagText", pos.x + 1, pos.y + 1, color_black, TEXT_ALIGN_CENTER )
		draw.SimpleText( entData.name, "dHeists_bagText", pos.x, pos.y, color_white, TEXT_ALIGN_CENTER )
	end )
end
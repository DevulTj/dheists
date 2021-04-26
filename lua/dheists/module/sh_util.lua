--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

function dHeists.isPolice( player )
	return dHeists.config.isPoliceFunction( player )
end

local WHITELIST = {
	[ "dheists_rob_ent_base" ] = true,
	[ "dheists_cctv_tv_base" ] = true,
	[ "dheists_cctv_camera_base" ] = true,
	[ "dheists_alarm_base" ] = true,
	[ "dheists_zone_screen_base" ] = true,
}

local RETURN_FUNCS = {
	[ "dheists_rob_ent_base" ] = function( ent ) return ent.GetEntityType and dHeists.robbing.getEnt( ent:GetEntityType() ) and dHeists.robbing.getEnt( ent:GetEntityType() ).name or ent:GetClass() end,
}

concommand.Add( "dheists_ent_export", function( player )
	local entities = ents.FindInSphere( player:GetPos(), 512 )

	local rnd = function( n )
		return math.Round( n )
	end

	local myStr = ""
	local function addEnt( ent, class, pos, ang )
		myStr = myStr .. "\n" .. [[{
	type = "${className}",
	pos = Vector( ${posX}, ${posY}, ${posZ} ),
	ang = Angle( ${angP}, ${angY}, ${angR} ),
},]] 	% {
			className = RETURN_FUNCS[ class ] and RETURN_FUNCS[ class ]( ent ) or class,
			posX = rnd( pos.x ), posY = rnd( pos.y ), posZ = rnd( pos.z ),
			angP = rnd( ang.p ), angY = rnd( ang.y ), angR = rnd( ang.r )
		}
	end

	for k, v in pairs( entities ) do
		local class = v:GetClass()
		if WHITELIST[ v:GetClass() ] then
			addEnt( v, class, v:GetPos(), v:GetAngles() )
		end
	end

	print( myStr )
end )

if CLIENT then
	function Derma_ComboRequest( strTitle, strText, tDropdownOptions, strSubmit, strSubmitCallback )

		local Window = vgui.Create( "DFrame" )
		Window:SetTitle( strTitle or "Message Title (First Parameter)" )
		Window:SetDraggable( false )
		Window:ShowCloseButton( true )
		Window:SetBackgroundBlur( true )
		Window:SetDrawOnTop( true )

		local InnerPanel = Window:Add( "DPanel" )
		InnerPanel:Dock( FILL )
		InnerPanel:SetPaintBackground( false )

		local Text = InnerPanel:Add( "DLabel" )
		Text:Dock( TOP )
		Text:DockMargin( 0, 0, 0, 4 )
		Text:SetText( strText or "Message Text (Second Parameter)" )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )
		Text:SetTextColor( color_white )

		local Combo = InnerPanel:Add( "DComboBox" )
		Combo:Dock( TOP )
		Combo:SetTall( 32 )
		Combo:SetValue( "Select an option" )

		for _, v in pairs( tDropdownOptions or {} ) do
			Combo:AddChoice( v )
		end

		local Confirm = InnerPanel:Add( "DButton" )
		Confirm:Dock( BOTTOM )
		Confirm:SetText( strSubmit or "Submit" )

		Confirm.DoClick = function( this )
			if strSubmitCallback then strSubmitCallback( this, Combo:GetSelected() ) end

			Window:Close()
		end

		Window:SetSize( 512, 108 )
		Window:Center()
		Window:MakePopup()

		return Window
	end
end

--[[
    © 2017 devultj.co, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

local CMoveData = FindMetaTable( "CMoveData" )
function CMoveData:RemoveKeys( keys )
	-- Using bitwise operations to clear the key bits.
	local newbuttons = bit.band( self:GetButtons(), bit.bnot( keys ) )
	self:SetButtons( newbuttons )
end

hook.Add( "SetupMove", "dHeists.setupMoveBags", function( player, moveData, commandData )
    if player._dHeistsBag then
        if moveData:KeyDown( IN_JUMP ) then
            moveData:RemoveKeys( IN_JUMP )
        end

        moveData:SetMaxSpeed( moveData:GetMaxSpeed() * dHeists.config.holdingBagMovementModifier )
        moveData:SetMaxClientSpeed( moveData:GetMaxClientSpeed() * dHeists.config.holdingBagMovementModifier )
    end
end )

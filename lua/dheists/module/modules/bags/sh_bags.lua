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
    if player:getBag() then
        if moveData:KeyDown( IN_JUMP ) then
            moveData:RemoveKeys( IN_JUMP )
        end

        local maxSpeed = moveData:GetMaxSpeed()
        local defaultModifier = math.Clamp( ( ( dHeists.config.holdingBagMovementModifier ) / #player:getBag().lootItems ), 0, dHeists.config.holdingBagMovementModifier )
        local modifier = ( dHeists.config.holdingBagMovementModifier - defaultModifier )

        moveData:SetMaxSpeed( moveData:GetMaxSpeed() * modifier )
        moveData:SetMaxClientSpeed( moveData:GetMaxClientSpeed() * modifier )
    end
end )

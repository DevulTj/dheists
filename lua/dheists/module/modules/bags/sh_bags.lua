--[[
    © 2021 Tony Ferguson, do not share, re-distribute or modify

    without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

dHeists.bags = dHeists.bags or {}
dHeists.bags.list = {}
dHeists.bags.typeToName = {}

function dHeists.bags.registerBag( bagName, data )

end

function dHeists.bags.getBag( bagName )
    return tonumber( bagName ) and dHeists.bags.list[ dHeists.bags.typeToName[ bagName ] ] or dHeists.bags.list[ bagName ]
end

hook.Run( "dHeists.bags.registerBag" )


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

        local reduction = dHeists.config.holdingBagMovementModifierPerItem * #player:getBag().lootItems
        local defaultModifier = math.Clamp( reduction, 0, dHeists.config.holdingBagMovementModifierMax )
        local modifier = 1 - defaultModifier

        moveData:SetMaxSpeed( moveData:GetMaxSpeed() * modifier )
        moveData:SetMaxClientSpeed( moveData:GetMaxClientSpeed() * modifier )
    end
end )

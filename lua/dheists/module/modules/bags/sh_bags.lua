--[[
    © 2017 devultj.co, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

dHeists.bags = dHeists.bags or {}
dHeists.bags.list = {}
dHeists.bags.typeToName = {}

local bagPos = dHeists.config.alternateBagPos and Vector( -7, -5, 0 ) or Vector( 0, 0, 10 )
local bagAng = dHeists.config.alternateBagPos and Angle( 90, 0, 110 ) or Angle( 80, 100, 20 )
local scale = dHeists.config.alternateBagPos and 0.8 or 1

function dHeists.bags.registerBag( bagName, data )
    if not bagName then return end

    data.name = bagName
    dHeists.bags.list[ bagName ] = data

    if not data.bagType then return end
    renderObjects:registerObject( "bag_" .. data.bagType, {
        model = "models/jessev92/payday2/item_Bag_loot.mdl",
        bone = "ValveBiped.Bip01_Spine",
        pos = bagPos,
        ang = bagAng,

        skin = data.skin,
        scale = scale
    } )

    dHeists.bags.typeToName[ data.bagType ] = bagName
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

        local maxSpeed = moveData:GetMaxSpeed()

        local reduction = dHeists.config.holdingBagMovementModifierPerItem * #player:getBag().lootItems

        local defaultModifier = math.Clamp( reduction, 0, dHeists.config.holdingBagMovementModifierMax )
        local modifier = 1 - defaultModifier

        moveData:SetMaxSpeed( moveData:GetMaxSpeed() * modifier )
        moveData:SetMaxClientSpeed( moveData:GetMaxClientSpeed() * modifier )
    end
end )

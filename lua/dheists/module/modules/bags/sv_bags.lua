--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

util.AddNetworkString( "dHeists.sendBagItems" )
util.AddNetworkString( "dHeists.dropBag" )


function dHeists.dropBag( player, noDrop )
    if player._dHeistsBag then
        local bagData = player._dHeistsBag

        local bag
        if not noDrop then
            bag = ents.Create( bagData.bagType )
            bag:SetPos( player:GetPos() + ( player:GetUp() * 50 ) + player:GetForward() * -5 )

            bag:Spawn()
            bag:Activate()

            bag:GetPhysicsObject():SetVelocity( player:EyeAngles():Forward()
                * ( dHeists.config.defaultBagThrowStrength or 300 )
                * ( player:KeyDown( IN_SPEED ) and ( dHeists.config.defaultBagThrowStrengthSprintMultiplier or 2 ) or 1  )
            ) -- Throw the bag in the player's direction

            bag:setLoot( bagData.lootItems )
            bag:SetEntityOwner( player ) -- Ownership property
        end

        player._dHeistsBag = nil
        player:setDevBool( "isCarryingBag", false )

        net.Start( "dHeists.dropBag" )
        net.Send( player )

        hook.Run( "dHeists.onDropBag", player, noDrop, bagData )

        if renderObjects then -- renderObjects support
            renderObjects:clearObject( player, bagData.bagType )
        end

        return bag
    end
end

if dHeists.config.dropBagCommand then
    concommand.Add( dHeists.config.dropBagCommand, function( ply )
        dHeists.dropBag( ply )
    end )
end

function dHeists.setBag( player, entity )
    if not entity.IsBag then return end

    player._dHeistsBag = {
        bagType = entity:GetClass(),
        lootItems = entity:getLoot(),
        capacity = entity:GetCapacity()
    }

    renderObjects:setObject( player, entity:GetClass() )
    player:setDevBool( "isCarryingBag", true )

    net.Start( "dHeists.sendBagItems" )
        net.WriteTable( entity:getLoot() )
    net.Send( player )

    hook.Run( "dHeists.onPickUpBag", player, player._dHeistsBag )
end

local effectData = EffectData()
local function doBalloons( entity )
    effectData:SetOrigin( entity:GetPos() + Vector( 0, 0, 30 ) )
    effectData:SetColor( 1 )

    util.Effect( "balloon_pop", effectData )
end

function dHeists.collectBag( npc, player )
    local bag = player._dHeistsBag
    if not bag then return end

    local lootItems = bag.lootItems
    local moneyGiven = 0

    if table.Count( lootItems ) < 1 then return end

    doBalloons( npc )

    local lootStuff = {}
    for _, lootName in pairs( lootItems ) do
        local lootData = dHeists.loot.getLoot( lootName )
        if not lootData then continue end

        moneyGiven = moneyGiven + ( lootData.moneyGiven or 0 )
        lootStuff[ lootName ] = ( lootStuff[ lootName ] or 0 ) + 1
    end

    local lootString = ""
    local count = 0
    for itemName, amount in pairs( lootStuff ) do
        local typeInfo = dHeists.loot.getLoot( itemName )
        if not typeInfo then continue end

        lootString = lootString .. ( count ~= 0 and ", " or "" ) .. ( amount > 1 and ( ( amount .. "x" ) or "" ) .. " " or "" ) .. dL( typeInfo.name )

        count = count + 1
    end

    dHeists.gamemodes:addMoney( player, moneyGiven )
    player:dHeistsNotify( dL( "bag_sold_text", string.formatMoney( moneyGiven ), lootString ) )

    dHeists.dropBag( player, true )
end

hook.Add( "PlayerDeath", "dHeists.bags", function( player )
    dHeists.dropBag( player )
end )

--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

util.AddNetworkString( "dHeists.sendBagItems" )
util.AddNetworkString( "dHeists.dropBag" )

concommand.Add( "dheists_debug_setbagtype", function( player, command, arguments )
    CAMI.PlayerHasAccess( dHeists.privileges.DEBUG_SETBAGTYPE, function( hasAccess )
        if not hasAccess then return end

        arguments = table.concat( arguments, " " )
        if not tonumber( arguments ) then return end

        local entity = player:GetEyeTrace().Entity
        if not IsValid( entity ) or not entity.IsBag then return end

        entity:setBagType( arguments )
    end )
end )

function dHeists.dropBag( player )
    if player._dHeistsBag then
        local bag = ents.Create( "dheists_bag_base" )
        bag:SetPos( player:GetPos() + ( player:GetUp() * 50 ) )

        bag:Spawn()
        bag:Activate()

        local bagData = player._dHeistsBag

        bag:GetPhysicsObject():SetVelocity( player:EyeAngles():Forward()
            * ( dHeists.config.defaultBagThrowStrength or 300 )
            * ( player:KeyDown( IN_SPEED ) and ( dHeists.config.defaultBagThrowStrengthSprintMultiplier or 2 ) or 1  )
        ) -- Throw the bag in the player's direction

        bag:setBagType( bagData.bagType )
        bag:setLoot( bagData.lootItems )

        if renderObjects then -- renderObjects support
            renderObjects:clearObject( player, "bag_" .. bagData.bagType )
        end

        player._dHeistsBag = nil
        player:SetNW2Bool( "dHeists_CarryingBag", false )

        bag:SetEntityOwner( player ) -- Ownership property

        net.Start( "dHeists.dropBag" )
        net.Send( player )
    end
end

concommand.Add( dHeists.config.dropBagCommand, dHeists.dropBag )

function dHeists.setBag( player, entity )
    if not entity.IsBag then return end

    player._dHeistsBag = {
        bagType = entity:GetBagType(),
        lootItems = entity:getLoot(),
        capacity = entity:GetCapacity()
    }

    renderObjects:setObject( player, "bag_" .. entity:GetBagType() )
    player:SetNW2Bool( "dHeists_CarryingBag", true )

    net.Start( "dHeists.sendBagItems" )
        net.WriteTable( entity:getLoot() )
    net.Send( player )
end

local effectData = EffectData()
local function doBalloons( entity )
    effectData:SetOrigin( entity:GetPos() + Vector( 0, 0, 30 ) )
    effectData:SetColor( 1 )

    util.Effect( "balloon_pop", effectData )
end

function dHeists.collectBag( npc, entity )
    local player = entity.GetEntityOwner and entity:GetEntityOwner()
    if not IsValid( player ) then return end

    local lootItems = entity:getLoot()
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
        lootString = lootString .. ( count ~= 0 and ", " or "" ) .. ( amount > 1 and ( ( amount .. "x" ) or "" ) .. " " or "" ) .. itemName

        count = count + 1
    end

    dHeists.addMoney( player, moneyGiven )

    frotify.notify(
        i18n.getPhrase( "bag_sold_text", string.formatMoney( moneyGiven ), lootString ),
        NOTIFY_GENERIC, 4, player )

    SafeRemoveEntity( entity )
end

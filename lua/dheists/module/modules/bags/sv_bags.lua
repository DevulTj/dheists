--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

concommand.Add( "dheists_debug_setbagtype", function( player, cmd, args )
    if not player:IsSuperAdmin() then return end

    args = table.concat( args, " " )
    if not tonumber( args ) then return end

    local entity = player:GetEyeTrace().Entity
    if not IsValid( entity ) or not entity.IsBag then return end

    entity:setBagType( args )
end )

function dHeists.dropBag( player )
    if player._dHeistsBag then
        local bag = ents.Create( "dheists_bag_base" )
        bag:SetPos( player:GetPos() + ( player:GetUp() * 50 ) )

        bag:Spawn()
        bag:Activate()

        bag:GetPhysicsObject():SetVelocity( player:EyeAngles():Forward()
            * ( dHeists.config.defaultBagThrowStrength or 300 )
            * ( player:KeyDown( IN_SPEED ) and ( dHeists.config.defaultBagThrowStrengthSprintMultiplier or 2 ) or 1  )
        ) -- Throw the bag in the player's direction

        bag:setBagType( player._dHeistsBag.bagType )

        if renderObjects then -- renderObjects support
            renderObjects:clearObject( player, "bag_" .. player._dHeistsBag.bagType )
        end

        player._dHeistsBag = nil
        player:SetNW2Bool( "dHeists_CarryingBag", false )

        bag:SetEntityOwner( player ) -- Ownership property
    end
end

concommand.Add( dHeists.config.dropBagCommand, dHeists.dropBag )

function dHeists.isPolice( player )
    return dHeists.config.isPoliceFunction( player )
end

local effectData = EffectData()
function dHeists.collectBag( npc, entity )
    effectData:SetOrigin( npc:GetPos() + Vector( 0, 0, 30 ) )
    effectData:SetColor( 1 )

    util.Effect( "balloon_pop", effectData )

    SafeRemoveEntity( entity )
end

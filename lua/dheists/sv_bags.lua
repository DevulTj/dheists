--[[
	© 2017 devultj.co, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

concommand.Add( dHeists.config.dropBagCommand, function( player, cmd, args )
    if player._dHeistsBag then
        local bag = ents.Create( "dheists_bag_base" )
        bag:SetPos( player:GetPos() + ( player:GetUp() * 50 ) )

        bag:Spawn()
        bag:Activate()

        bag:GetPhysicsObject():SetVelocity( player:EyeAngles():Forward() 
            * ( dHeists.config.defaultBagThrowStrength or 300 ) 
            * ( player:KeyDown( IN_SPEED ) and ( dHeists.config.defaultBagThrowStrengthSprintMultiplier or 2 ) or 1  )
        )

        bag:setBagType( player._dHeistsBag.bagType )
        renderObjects:clearObject( player, "bag_" .. player._dHeistsBag.bagType )

        player._dHeistsBag = nil
        player:SetNW2Bool( "dHeists_CarryingBag", false )
    end
end )
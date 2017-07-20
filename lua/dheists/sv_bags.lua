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

        print("Do shit")
        bag:GetPhysicsObject():SetVelocity( player:GetForward() * 300 + Vector( 0, 0, 20 ) )

        bag:SetBagType( player._dHeistsBag.bagType )
        renderObjects:clearObject( player, player._dHeistsBag.objectName )

        player._dHeistsBag = nil
    end
end )
--[[
	© 2017 devultj.co.uk, do not share, re-distribute or modify
	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

renderObjects = renderObjects or {}
renderObjects.objectList = renderObjects.objectList or {}
renderObjects.objectDatabase = renderObjects.objectDatabase or {}

--[[
    function: renderObjects.getObjects
    arguments: none
    description: Returns the object list table
]]

function renderObjects:getObjects()
    return self.objectList
end

--[[
    function: renderObjects.getPlayer
    arguments: Player player
    description: Ensures the player's object list exists
]]

function renderObjects:getPlayer( player )
    return self.objectList[ player ]
end

--[[
    function: renderObjects.setPlayer
    arguments: Player player
    description: Creates a new table for a player, or does nothing if it already exists
]]

function renderObjects:setPlayer( player )
    self.objectList[ player ] = self.objectList[ player ] or {}

    hook.Run( "renderObjects.setPlayer", player, objectData )

    return self.objectList[ player ]
end

--[[
    function: renderObjects.setObjects
    arguments: Table objects
    description: Sets objects globally with the desired objects
]]

function renderObjects:setObjects( objects )
    self.objectList = objects

    hook.Run( "renderObjects.setObjects", objects )

    return objects
end

--[[
    function: renderObjects.setObjectsOfPlayer
    arguments: Player player, Table objects
    description: Sets objects onto the desired player with the desired objects
]]

function renderObjects:setObjectsOfPlayer( player, objects )
    self.objectList[ player ] = objects

    hook.Run( "renderObjects.setObjectsOfPlayer", player, objects )

    return objects
end

--[[
    function: renderObjects.setObject
    arguments: Player player, Table objectData
    description: Sets an object onto the desired player with the desired object data
]]

function renderObjects:setObject( player, objectName )
    local playerData = self:setPlayer( player )

    playerData[ objectName ] = true

    hook.Run( "renderObjects.setObject", player, objectName )

    return index
end

--[[
    function: renderObjects.clearObject
    arguments: Player player, Int objectIndex
    description: Clear's a single object for a player
]]

function renderObjects:clearObject( player, objectName )
    if not self:getPlayer( player ) then return end

    hook.Run( "renderObjects.clearObject", player, objectName )

    if CLIENT then
        local objectEntity = self.objectList[ player ][ objectName ]
        if IsValid( objectEntity ) then objectEntity:Remove() end
    end

    self.objectList[ player ][ objectName ] = nil
end

--[[
    function: renderObjects.clearPlayer
    arguments: Player player
    description: Clears a player's object table
]]

function renderObjects:clearPlayer( player )
    if not self:getPlayer( player ) then return end

    hook.Run( "renderObjects.clearPlayer", player )

    self.objectList[ player ] = nil
end

if SERVER then
    --[[
        function: renderObjects.load
        arguments: Player player
        description: Load all objects and send to the desired player
    ]]

    function renderObjects:load( player )
        local objectList = self:getObjects()

        -- We're running in the server realm, so we can use net messages!
        net.Start( "renderObjects.loadObjects" )
            net.WriteTable( objectList )
        net.Send( player )

        hook.Run( "renderObjects.loadObjects", player, objectList )
    end
end

--[[
        function: renderObjects.registerObject
        arguments: Table objectData
        description: Registers an object database entry to use when setting an object on a player
        Example object data:
            objectData = {
                name = "pop_can",
                model = "models/props_junk/PopCan01a.mdl",
                bone = "ValveBiped.Bip01_Head1",
                pos = Vector( 0, 0, 2 ),
                ang = Angle( 0, 180, 0 ),
                scale = 2
            }
]]

function renderObjects:registerObject( objectName, objectData )
    if not objectName then return end

    objectData.name = objectName
    self.objectDatabase[ objectName ] = objectData

    hook.Run( "renderObjects.registerObject", objectData )

    MsgC( Color( 255, 0, 0 ), "[renderObjects] ", color_white, "Registered object '" .. objectName .. "'\n" )
end

function renderObjects:getRegisteredObject( objectName )
    return self.objectDatabase[ objectName ]
end

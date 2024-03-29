--[[
    © 2021 Tony Ferguson, do not share, re-distribute or modify

    without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

local PLAYER = FindMetaTable( "Player" )

function PLAYER:addMask( mask )
    if #self:getMask() ~= 0 then return false, "You already have a Mask equipped." end

    self:setDevString( "currentMask", mask )
    self:dHeistsNotify( "You picked up a mask.", NOTIFY_GENERIC )

    return true
end


function PLAYER:getMask()
    return self:getDevString( "currentMask", nil )
end

if SERVER then
    -- Optimization
    local function maskUnEquip( player, currentMask )
        player:setDevBool( "maskEquipped", false )
        player:runMaskEffect()

        renderObjects:clearObject( player, currentMask )

        hook.Run( "dHeists.maskUnEquipped", player, currentMask )
    end

    function PLAYER:dropMask( force )
        if #self:getMask() == 0 then return end

        local currentMask = self:getMask()

        if force then
            maskUnEquip( self, currentMask )
        end

        if not currentMask then
            -- Something that shouldn't ever happen, right here!

            return
        end

        if self:getDevBool( "maskEquipped", false ) then
            self:dHeistsNotify( "Please un-equip your mask before dropping it.", NOTIFY_GENERIC )

            return
        end

        self:setDevString( "currentMask", nil )
        self:dHeistsNotify( "You dropped your mask.", NOTIFY_GENERIC )

        local mask = ents.Create( currentMask )
        mask:SetPos( self:GetPos() + ( self:GetUp() * 50 ) + ( self:GetForward() * 20 ) )

        mask:Spawn()
        mask:Activate()

        return mask
    end

    function PLAYER:runMaskEffect()
        self:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 0.6, 0.1 )
        self:EmitSound( "npc/combine_soldier/gear" .. math.random( 1, 3 ) .. ".wav" )
    end

    function PLAYER:equipMask()
        if self:getMask() == "" then return end

        local currentMask = self:getMask()

        -- Two types here, if the specified key is down, we drop the mask, if not, we equip it.
        if self:KeyDown( IN_SPEED ) then
            dHeists.actions.doAction( self, dHeists.config.equipMaskTime or 1.5, function()
                self:dropMask()
            end, {
                -- Will edit values later
                ActionTimeRemainingTextPhrase = "dropping_mask",
                HoldKey = dHeists.config.maskEquipKey
            } )
        else
            dHeists.actions.doAction( self, dHeists.config.equipMaskTime or 1.5, function()
                self:setDevBool( "maskEquipped", true )
                self:runMaskEffect()

                renderObjects:setObject( self, currentMask )

                if dHeists.config.playMaskEquipSound then self:playMaskEquipSound() end

                hook.Run( "dHeists.maskEquipped", self, currentMask )
            end, {
                -- Will edit values later
                ActionTimeRemainingTextPhrase = "equipping_mask",
                HoldKey = dHeists.config.maskEquipKey
            } )
        end
    end

    function PLAYER:unEquipMask()
        if self:getMask() == "" then return end

        dHeists.actions.doAction( self, dHeists.config.unEquipMaskTime or 1.5, function()
            maskUnEquip( self, self:getMask() )
        end, {
            -- Will edit values later
            ActionTimeRemainingTextPhrase = "un_equipping_mask",
            HoldKey = dHeists.config.maskEquipKey
        } )
    end

    function PLAYER:playMaskEquipSound()
        local isFemale = string.find( self:GetModel(), "female" )

        local sounds = dHeists.config.maskOnSounds[ isFemale and "female" or "male" ]
        local selectedSound = sounds[ math.random( 1, #sounds ) ]

        self:EmitSound( selectedSound )
    end

    function PLAYER:toggleMask()
        if self:getMask() == "" then return end

        if self:getDevBool( "maskEquipped", false ) then
            self:unEquipMask()
        else
            self:equipMask()
        end
    end
end

hook.Add( "PlayerDeath", "dHeists.masks", function( player )
    player:dropMask( true )
end )

--[[
    © 2018 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
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
    local function maskUnEquip( player, maskInfo )
        player:setDevBool( "maskEquipped", false )
        player:runMaskEffect()

        renderObjects:clearObject( player, "mask_" .. maskInfo.name )

        hook.Run( "dHeists.maskUnEquipped", player, maskInfo )
    end

    function PLAYER:dropMask( force )
        if #self:getMask() == 0 then return end

        if force then
            local maskInfo = dHeists.masks.getMask( self:getMask() )
            if not maskInfo then return end

            maskUnEquip( self, maskInfo )
        end

        if self:getDevBool( "maskEquipped", false ) then
            self:dHeistsNotify( "Please un-equip your mask before dropping it.", NOTIFY_GENERIC )

            return
        end

        local currentMask = self:getDevString( "currentMask", nil )
        if not currentMask then
            -- Something that shouldn't ever happen, right here!

            return
        end

        self:setDevString( "currentMask", nil )
        self:dHeistsNotify( "You dropped your mask.", NOTIFY_GENERIC )

        local mask = ents.Create( "dheists_mask_base" )
        mask:SetPos( self:GetPos() + ( self:GetUp() * 50 ) + ( self:GetForward() * 20 ) )

        mask:Spawn()
        mask:Activate()
        
        mask:setMaskType( currentMask )
    end

    function PLAYER:runMaskEffect()
        self:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 0.6, 0.1 )
        self:EmitSound( "npc/combine_soldier/gear" .. math.random( 1, 3 ) .. ".wav" )
    end

    function PLAYER:equipMask()
        if not self:getMask() then return end

        local maskInfo = dHeists.masks.getMask( self:getMask() )
        if not maskInfo then return end

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

                renderObjects:setObject( self, "mask_" .. maskInfo.name )
                
                if dHeists.config.playMaskEquipSound then self:playMaskEquipSound() end

                hook.Run( "dHeists.maskEquipped", self, maskInfo )
            end, {
                -- Will edit values later
                ActionTimeRemainingTextPhrase = "equipping_mask",
                HoldKey = dHeists.config.maskEquipKey
            } )
        end
    end

    function PLAYER:unEquipMask()
        if not self:getMask() then return end

        local maskInfo = dHeists.masks.getMask( self:getMask() )
        if not maskInfo then return end

        dHeists.actions.doAction( self, dHeists.config.unEquipMaskTime or 1.5, function()
            maskUnEquip( self, maskInfo )
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
        if not self:getMask() then return end

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
--[[
    © 2017 devultj.co.uk, do not share, re-distribute or modify

    without permission of its author (devultj@gmail.com).
]]

local PLAYER = FindMetaTable( "Player" )

function PLAYER:addMask( mask )
    if #self:getMask() ~= 0 then return false, "You already have a Mask equipped." end

    self:setDevString( "currentMask", mask )
    frotify.notify( "You picked up a Mask.", NOTIFY_GENERIC, 4, self )

    return true
end

function PLAYER:getMask()
    return self:getDevString( "currentMask", nil )
end

if SERVER then
    function PLAYER:equipMask()
        if not self:getMask() then return end

        local maskInfo = dHeists.masks.getMask( self:getMask() )
        if not maskInfo then return end

        dHeists.actions.doAction( self, dHeists.config.equipMaskTime or 1.5, function()
            self:setDevBool( "maskEquipped", true )

            renderObjects:setObject( self, "mask_" .. maskInfo.name )
        end, {
            -- Will edit values later
            ActionTimeRemainingText = "EQUIPPING MASK"
        } )
    end

    function PLAYER:unEquipMask()
        if not self:getMask() then return end

        local maskInfo = dHeists.masks.getMask( self:getMask() )
        if not maskInfo then return end

        dHeists.actions.doAction( self, dHeists.config.unEquipMaskTime or 1.5, function()
            self:setDevBool( "maskEquipped", false )

            renderObjects:clearObject( self, "mask_" .. maskInfo.name )
        end, {
            -- Will edit values later
            ActionTimeRemainingText = "UN-EQUIPPING MASK"
        } )
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
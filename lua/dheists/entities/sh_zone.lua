
DEFINE_BASECLASS( "trigger_brush" )

ENT = {}

ENT.Base = "trigger_brush"
ENT.Type = "anim"
ENT.Author = "fruitwasp"
ENT.PrintName = "Zone"
ENT.Category = "dHeists"

ENT.Spawnable = true
ENT.AdminSpawnable	= true

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "CooldownTime" )
    self:NetworkVar( "Int", 1, "PlayerCount" )
end

function ENT:hasCooldown()
    return self:GetCooldownTime() > CurTime()
end

if SERVER then
    function ENT:Initialize()
        self.playersInside = {}
        self:SetPlayerCount( 0 )
        self:SetCooldownTime( 0 )
    end

    function ENT:playerIsInside( player )
        return self.playersInside[ player ] or false
    end

    function ENT:enterPlayer( player )
        if self:playerIsInside( player ) then

            return
        end

        self.playersInside[ player ] = true
        self:SetPlayerCount( self:GetPlayerCount() + 1 )
    end

    function ENT:exitPlayer( player )
        if not self:playerIsInside( player ) then

            return
        end

        self.playersInside[ player ] = nil
        self:SetPlayerCount( self:GetPlayerCount() - 1 )
    end

    function ENT:StartTouch( player )
        if self:hasCooldown() then

            return
        end

        self:enterPlayer( player )
    end

    function ENT:EndTouch( player )
        self:exitPlayer( player )

        if self:GetPlayerCount() < 1 then
            self:SetCooldownTime( math.floor( CurTime() + dHeists.config.get( "zoneCooldownTime" ) ) )
        end
    end

    gameevent.Listen( "player_disconnect" )
    hook.Add( "player_disconnect", dHeists.IDENTIFIER, function( data )
        local player = Player( data.userid )

        for zone, _ in pairs( _zones ) do
            zone:exitPlayer( player )
        end
    end )

    hook.Add( "EntityCreated", dHeists.IDENTIFIER .. "zones", function( entity )
        if entity.IsZone then
            _zones[ entity ] = true
        end
    end )

    hook.Add( "EntityRemoved", dHeists.IDENTIFIER .. "zones", function( entity )
        if entity.IsZone then
            _zones[ entity ] = nil
        end
    end )

    hook.Add( "PlayerUse", dHeists.IDENTIFIER .. "zones", function( player, entity )
        if player.inZones then
            for zone, _ in pairs( player.inZones ) do
                if zone:hasCooldown() then
                    return false
                end
            end
        end
    end )

    local PLAYER = FindMetaTable( "Player" )

    function PLAYER:addInZone( zone )
        if self.inZones[ zone ] then

            return
        end

        self.inZones[ zone ] = true
    end

    function PLAYER:removeInZone( zone )
        if not self.inZones[ zone ] then

            return
        end

        self.inZones[ zone ] = nil
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end

scripted_ents.Register( ENT, "dheists_zone" )

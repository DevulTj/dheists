
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
        if self:GetCooldownTime() > CurTime() then

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

    gamevent.Listen( "player_disconnect" )
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
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end

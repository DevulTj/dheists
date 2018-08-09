--##NoSimplerr##

--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com) - {{ user_id }} - Script ID: {{ script_version_name }}
]]

function dHeists.teamsFromNames( tbl )
    if not tbl then return end

    local newTbl = {}
    local jobList = dHeists.gamemodes:getJobList()

    for _, data in pairs( jobList ) do
        if table.HasValue( tbl, data.name ) then
            table.insert( newTbl, data.team )
        end
    end

    return newTbl
end

local function registerBags()
    local bagList = dHeists.bags.list
    if not bagList then return end

    for bagName, data in pairs( bagList ) do
        print( "Registering dHeists bag " .. bagName )

        DarkRP.createEntity( dL( bagName ), {
            ent = "dheists_bag_base",
            model = "models/jessev92/payday2/item_Bag_loot.mdl",
            price = data.worth or 1000,
            max = data.max or 10,
            cmd = "buy" .. bagName,

            allowed = dHeists.teamsFromNames( data.teams ),
            category = "dHeists", -- The name of the category it is in. Note: the category must be created!

            dHeistsBag = data.bagType
        })
    end
end

local function registerMasks()
    local maskList = dHeists.masks.list
    if not maskList then return end

    for maskName, data in pairs( maskList ) do
        print( "Registering dHeists mask " .. maskName )

        DarkRP.createEntity( maskName, {
            ent = "dheists_mask_base",
            model = data.model,
            price = data.worth or 1000,
            max = data.max or 10,
            cmd = "buy" .. string.Replace( maskName, " ", "_" ),

            allowed = dHeists.teamsFromNames( data.teams ),
            category = "dHeists", -- The name of the category it is in. Note: the category must be created!

            dHeistsMask = true
        })
    end
end

local function registerDrill()
    print( "Registering dHeists drill " )

    DarkRP.createEntity( "Drill", {
        ent = "dheists_drill_base",
        model = dHeists.config.drillModel,
        price = dHeists.config.drillWorth or 2500,
        max = 10,
        cmd = "buydrill",

        allowed = dHeists.teamsFromNames( dHeists.config.drillTeams ),
        category = "dHeists", -- The name of the category it is in. Note: the category must be created!
    })
end

local function RegisterItems()
    if not dHeists or not dHeists.bags then return end

    DarkRP.createCategory {
        name = "dHeists",
        categorises = "entities",
        canSee = fp{ fn.Id, true },
        sortOrder = 102,
        color = Color( 0, 100, 200 ),
        startExpanded = true
    }

    registerBags()
    registerMasks()
    registerDrill()
end

hook.Add( "dHeists.onGamemodeLoaded", "DarkRP.dHeists", RegisterItems )

hook.Add( "playerBoughtCustomEntity", "DarkRP.dHeists", function( player, entityTable, ent, price )
    if entityTable.category ~= "dHeists" then return end

    -- Masks support
    if entityTable.dHeistsMask then
        ent:setMaskType( entityTable.name )
    end
end )
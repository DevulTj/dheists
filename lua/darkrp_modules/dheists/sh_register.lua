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

local function registerAll()
    for sClass, tData in pairs( scripted_ents.GetList() ) do
        if string.find( sClass, "_base" ) then continue end

        local tEntityData = tData.t
        if tEntityData.IsBag then
            print( "Bag found", tEntityData.PrintName )
            DarkRP.createEntity( tEntityData.PrintName, {
                ent = sClass,
                model = "models/jessev92/payday2/item_Bag_loot.mdl",
                price = tEntityData.BagPrice,
                max = tEntityData.BagLimit or 10,
                cmd = "buy" .. sClass,
                skin = tEntityData.BagSkin or 0,

                allowed = dHeists.teamsFromNames( tEntityData.BagTeams ) or nil,
                category = "dHeists", -- The name of the category it is in. Note: the category must be created!
            })
        elseif tEntityData.IsDrill then
            print( "Drill found", tEntityData.PrintName )
            DarkRP.createEntity( tEntityData.PrintName, {
                ent = sClass,
                model = dHeists.config.drillModel,
                price = tEntityData.DrillPrice or dHeists.config.drillWorth or 2500,
                max = 10,
                cmd = "buy" .. sClass,
                skin = tEntityData.DrillSkin or 0,
                allowed = dHeists.teamsFromNames( tEntityData.DrillTeams or dHeists.config.drillTeams ),
                category = "dHeists", -- The name of the category it is in. Note: the category must be created!
            })
        end
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

    registerAll()
    registerMasks()
end

hook.Add( "dHeists.onGamemodeLoaded", "DarkRP.dHeists", RegisterItems )

RegisterItems()

hook.Add( "playerBoughtCustomEntity", "DarkRP.dHeists", function( player, entityTable, ent, price )
    if entityTable.category ~= "dHeists" then return end

    -- Masks support
    if entityTable.dHeistsMask then
        ent:setMaskType( entityTable.name )
    end
end )
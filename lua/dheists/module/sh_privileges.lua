
dHeists.privileges = {
    RELOAD_ZONES = "dHeists_reload_zones",
    RELOAD_ENTS = "dHeists_reload_ents",
    DEBUG_SET_BAG_TYPE = "dHeists_debug_set_bag_type",
    EDIT_ZONES = "dHeists_edit_zones",
    DELETE_ZONES = "dHeists_delete_zones",
}

function dHeists.registerPrivilege( data )
    CAMI.RegisterPrivilege( data )
end

local function registerPrivileges()
    dHeists.registerPrivilege {
        Name = dHeists.privileges.RELOAD_ZONES,
        Description = "",
        MinAccess = "superadmin"
    }

    dHeists.registerPrivilege {
        Name = dHeists.privileges.RELOAD_ENTS,
        MinAccess = "superadmin"
    }

    dHeists.registerPrivilege {
        Name = dHeists.privileges.DEBUG_SET_BAG_TYPE,
        MinAccess = "superadmin"
    }

    dHeists.registerPrivilege {
        Name = dHeists.privileges.EDIT_ZONES,
        MinAccess = "superadmin"
    }

    dHeists.registerPrivilege {
        Name = dHeists.privileges.DELETE_ZONES,
        MinAccess = "superadmin"
    }
end

registerPrivileges()
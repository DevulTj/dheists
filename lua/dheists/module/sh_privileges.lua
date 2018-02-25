
dHeists.privileges = {
    RELOAD_ZONES = "dHeists_reload_zones",
    RELOAD_ENTS = "dHeists_reload_ents",
    DEBUG_SET_BAG_TYPE = "dHeists_debug_set_bag_type",
}

CAMI.RegisterPrivilege {
    Name = dHeists.privileges.RELOAD_ZONES,
    Description = "",
    MinAccess = "admin"
}

CAMI.RegisterPrivilege {
    Name = dHeists.privileges.RELOAD_ENTS,
    MinAccess = "admin"
}

-- DEBUG PRIVILEGES
CAMI.RegisterPrivilege {
    Name = dHeists.privileges.DEBUG_SET_BAG_TYPE,
    MinAccess = "superadmin"
}

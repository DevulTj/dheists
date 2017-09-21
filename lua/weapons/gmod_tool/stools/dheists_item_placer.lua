
TOOL.Category = "dHeists"
TOOL.Name = "Item Placer"
TOOL.Author = "fruitwasp"
TOOL.AuthorUrl = "https://steamcommunity.com/id/fruitwasp"

TOOL.ClientConVar[ "entity" ] = ""
TOOL.ClientConVar[ "vector" ] = "0 0 0"
TOOL.ClientConVar[ "angle" ] = "0 0 0"

TOOL.Information = {
    { name = "left" },
    { name = "right" }
}

function TOOL:LeftClick( trace )
end

function TOOL:RightClick( trace )
end

function TOOL:Reload()
end

function TOOL:Holster()
end

function TOOL:BuildCPanel()
    self:AddControl( "Slider", {
        Label = "Lootable entity",
        Command = "dheists_item_placer_entity"
    } )
end

hook.Add( "Think", "dHeistsItemPlacer", function()

end )

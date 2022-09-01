--[[
    Weapon class: defines behavior for all weapons in the game.
    attributes: inflictions{}
    @author Saverton
]]

Weapon = Class{__includes = Item}

function Weapon:init(name, holder)
    Item.init(self, name, holder)
end

function Weapon:use(target)
    Item.use(self)
end
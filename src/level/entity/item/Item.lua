--[[
    Item class: defines behavior for all items in the game.
    attributes: market price (buy/sell), name, texture, frame, onUse(), holder (reference), useRate
    @author Saverton
]]

Item = Class{}

function Item:init(name, holder)
    self.name = name

    self.holder = holder
end

function Item:use()
    return ITEM_DEFS[self.name].onUse(self, self.holder)
end

function Item:render(x, y)
    local def = ITEM_DEFS[self.name]
    love.graphics.draw(gTextures[def.texture], gFrames[def.texture][def.frame], x, y)
end
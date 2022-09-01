--[[
    Item class: defines behavior for all items in the game.
    attributes: market price (buy/sell), name, texture, frame, onUse(), holder (reference), useRate
    @author Saverton
]]

Item = Class{}

function Item:init(name, holder)
    self.name = name

    self.holder = holder

    self.useRate = 0
end

function Item:update(dt)
    self.useRate = math.max(0, self.useRate - dt)
end

function Item:use()
    self.useRate = ITEM_DEFS[self.name].useRate
    print('use rate: ' .. tostring(self.useRate))
    return ITEM_DEFS[self.name].onUse(self, self.holder)
end

function Item:render(x, y)
    local def = ITEM_DEFS[self.name]
    love.graphics.draw(gTextures[def.texture], gFrames[def.texture][def.frame], x, y)
end
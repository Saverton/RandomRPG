--[[
    Item class: defines behavior for all items in the game.
    attributes: market price (buy/sell), name, texture, frame, onUse(), holder (reference), useRate
    @author Saverton
]]

Item = Class{}

function Item:init(name, holder, quantity)
    self.name = name

    self.holder = holder

    self.useRate = 0

    if ITEM_DEFS[self.name].type == 'pickup' then
        ITEM_DEFS[self.name].onPickup(self.holder, quantity)
    end
end

function Item:update(dt)
    self.useRate = math.max(0, self.useRate - dt)
end

function Item:use()
    local item = ITEM_DEFS[self.name]
    self.useRate = item.useRate
    if item.type == 'ranged' then
        if not self.holder:useAmmo(item.cost) then
            goto noUse
        end
    elseif item.type == 'magic' then
        if not self.holder:useMagic(item.cost) then
            goto noUse
        end
    end
    item.onUse(self, self.holder)
    ::noUse::
end

function Item:render(x, y)
    local def = ITEM_DEFS[self.name]
    love.graphics.draw(gTextures[def.texture], gFrames[def.texture][def.frame], x, y)
end
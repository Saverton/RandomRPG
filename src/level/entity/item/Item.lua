--[[
    Item class: defines behavior for all items in the game.
    attributes: market price (buy/sell), name, texture, frame, onUse(), holder (reference), useRate
    @author Saverton
]]

Item = Class{}

function Item:init(name, holder, quantity)
    self.name = name

    self.holder = holder

    self.useRate = ITEM_DEFS[self.name].useRate

    self.quantity = quantity or 1

    if ITEM_DEFS[self.name].type == 'pickup' then
        ITEM_DEFS[self.name].onPickup(self.holder, quantity)
    end
end

function Item:update(dt)
    self.useRate = math.max(0, self.useRate - dt)
end

-- use this item
function Item:use()
    local successful = false -- track whether the item was used
    local item = ITEM_DEFS[self.name] -- shortened reference to the item's definitions table
    -- ensure that any ammo or magic requirements are met
    if not (item.type == 'ranged' and self.holder:useAmmo(item.cost)) and not (item.type == 'magic' and self.holder:useMagic(item.cost)) then
        gSounds['items'][ITEM_DEFS[self.name].useSound or 'hit']:play() -- play the item's use sound
        item.onUse(self, self.holder) -- execute the items onUse behavior
        self.useRate = item.useRate -- set the item's cooldown timer to the useRate
        successful = true -- item was used successfully
    end
    return successful
end

function Item:render(x, y)
    local def = ITEM_DEFS[self.name]
    love.graphics.draw(gTextures[def.texture], gFrames[def.texture][def.frame], x, y)
end

function Item:getQuantityText()
    local text = ''
    if self.quantity > 1 then
        text = ' ... (' .. tostring(self.quantity) .. ')'
    end
    return text
end
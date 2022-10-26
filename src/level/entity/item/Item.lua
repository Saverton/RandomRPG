--[[
    Item class: defines behavior for all items in the game. Items have a name, a reference to their holder/owner, a use rate timer, and
    a quantity
    @author Saverton
]]

Item = Class{}

function Item:init(name, holder, quantity)
    self.name = name -- name of the item
    self.holder = holder -- reference to the holder
    self.useRate = ITEM_DEFS[self.name].useRate -- timer that tracks when the item is in cooldown
    self.quantity = quantity or 1 -- the quantity of this item
    self:checkForPickup() -- check if this item is just a pickup
end

-- update item useRate timer
function Item:update(dt)
    self.useRate = math.max(0, self.useRate - dt)
end

-- draw the item, used in inventory
function Item:render(x, y)
    local definition = ITEM_DEFS[self.name]
    love.graphics.draw(gTextures[definition.texture], gFrames[definition.texture][definition.frame], x, y)
end

-- use the item, return true if successfully used, false otherwise
function Item:use()
    local successful = false -- track whether the item was used
    local item = ITEM_DEFS[self.name] -- shortened reference to the item's definitions table
    -- ensure that any ammo or magic requirements are met and that the use rate is 0
    if self.useRate == 0 and not (item.type == 'ranged' and not self.holder:useAmmo(item.cost)) and 
        not (item.type == 'magic' and not self.holder:useMana(item.cost)) then
        gSounds['items'][ITEM_DEFS[self.name].useSound or 'bow_shot']:play() -- play the item's use sound
        item.onUse(self, self.holder) -- execute the items onUse behavior
        self.useRate = item.useRate -- set the item's cooldown timer to the useRate
        successful = true -- item was used successfully
    end
    return successful
end

-- return a string with the quantity of the item
function Item:getQuantityText()
    local text = ''
    if self.quantity > 1 then -- only display text if the quantity is greater than 1
        text = ' ... (' .. tostring(self.quantity) .. ')'
    end
    return text
end

-- if this item is a pickup, just call its onPickup function
function Item:checkForPickup()
    if ITEM_DEFS[self.name].type == 'pickup' then
        ITEM_DEFS[self.name].onPickup(self.holder, self.quantity)
    end
end

-- return the use range (in pixels) that this item should be used in by a non-player entity
function Item:getUseRange()
    print(self.holder.heldItem)
    for i, item in ipairs(self.holder.items) do
        print(item.name)
    end
    return (ITEM_DEFS[self.name].useRange * TILE_SIZE) -- the use range (in tiles) multiplied by the size of a tile.
end
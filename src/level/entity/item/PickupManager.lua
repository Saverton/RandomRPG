--[[
    Pickup Manager: manages all pickups on the ground in a level.
    @author Saverton
]]

PickupManager = Class{}

function PickupManager:init(level, pickups)
    self.level = level -- reference to owner level
    self.pickups = pickups or {} -- pickups in this manager
end

-- update all pickups, check for pickup by player
function PickupManager:update(dt)
    for i, pickup in pairs(self.pickups) do
        if GetDistance(self.level.player, pickup) < PICKUP_RANGE then
            local item = Item(pickup.name, self.level.player, pickup.quantity) -- item made from pickup
            local pickupSound = ITEM_DEFS[pickup.name].pickupSound or 'pickup_item'
            self.level.player:giveItem(item)
            gSounds['items'][pickupSound]:stop() -- play pickup sound
            gSounds['items'][pickupSound]:play() -- play pickup sound
            if pickupSound == 'special_item' then
                self.level.player:changeState('item-get', {item = item}) -- make the player perform the special pickup animation
            end
            table.remove(self.pickups, i) -- remove this pickup
        end
    end
end

-- render all pickups within the pickup render range of the player
function PickupManager:render(camera)
    for i, pickup in pairs(self.pickups) do
        if GetDistance(self.level.player, pickup) < (PICKUP_RENDER_RANGE * TILE_SIZE) then
            pickup:render(camera) -- render the pickup if in range
        end
    end
end

-- spawn new pickups into the level from a list of items
function PickupManager:spawnPickups(items)
    for i, item in pairs(items) do
        table.insert(self.pickups, Pickup(item.name, {x = item.x, y = item.y}, item.quantity)) -- add a new pickup
    end
end
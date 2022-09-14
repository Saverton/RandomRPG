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
            if ITEM_DEFS[item.name].type ~= 'pickup' then -- add to player inventory if not a pickup
                self.level.player:giveItem(item)
            end
            gSounds['items'][ITEM_DEFS[pickup.name].pickupSound or 'pickup_item']:play() -- play pickup sound
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
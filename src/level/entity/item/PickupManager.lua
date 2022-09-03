--[[
    Pickup Manager: manages all pickups on the ground in a level.
    @author Saverton
]]

PickupManager = Class{}

function PickupManager:init(level)
    self.level = level

    self.pickups = {}
end

function PickupManager:update(dt)
    for i, pickup in pairs(self.pickups) do
        if GetDistance(self.level.player, pickup) < self.level.player.pickupRange then
            self.level.player:getItem(Item(pickup.name, self.level.player, pickup.value))
            love.audio.play(gSounds['pickup_item'])
            table.remove(self.pickups, i)
        end
    end
end

function PickupManager:render(camera)
    for i, pickup in pairs(self.pickups) do
        if GetDistance(self.level.player, pickup) < PICKUP_RENDER_RANGE * TILE_SIZE then
            pickup:render(camera)
        end
    end
end

function PickupManager:spawnPickups(items)
    for i, item in pairs(items) do
        local x, y = self.level:getRandomCoord()
        while not self.level.map:isSpawnableSpace(x, y) do
            x, y = self.level:getRandomCoord()
        end
        table.insert(self.pickups, Pickup(item, (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE))
    end
end
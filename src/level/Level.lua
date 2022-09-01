--[[
    Level class: combines all elements of a level (map, entities, player, camera, etc.)
    attributes: map, entities, player, camera
    @author Saverton
]]

Level = Class{}

function Level:init(map, player, enemySpawner)
    self.map = map or Map('my_map', DEFAULT_MAP_SIZE)
    
    self.player = player or Player(ENTITY_DEFS['player'], self, self:getPlayerSpawnSpace(), {x = PLAYER_SPAWN_X_OFFSET, y = PLAYER_SPAWN_Y_OFFSET})
    self.player.stateMachine = StateMachine({
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['walk'] = function() return PlayerWalkState(self.player, self) end,
        ['interact'] = function() return EntityInteractState(self.player) end
    })
    self.player:changeState('idle')

    self.enemySpawner = enemySpawner or EnemySpawner(self, DEFAULT_ENTITY_CAP)

    self.pickups = {}
    self:generatePickups()

    self.camera = Camera(self.player, self)

    Timer.every(10, function() return self.enemySpawner:spawnEnemies() end)
end

function Level:getPlayerSpawnSpace()
    local x, y = self:getRandomCoord()

    while not self.map:isSpawnableSpace(x, y) do
        x, y = self:getRandomCoord()
    end

    return {x = x, y = y}
end

function Level:update(dt)
    self.map:update(dt)

    self.enemySpawner:update(dt)

    self.player:update(dt)

    for i, pickup in pairs(self.pickups) do
        if GetDistance(self.player, pickup) < self.player.pickupRange then
            self.player:getItem(Item(pickup.name, self.player, pickup.value))
            love.audio.play(gSounds['pickup_item'])
            table.remove(self.pickups, i)
        end
    end

    self.camera:update()
end

function Level:render()
    self.map:render(self.camera)

    for i, pickup in pairs(self.pickups) do
        pickup:render(self.camera)
    end

    self.enemySpawner:render(self.camera)

    self.player:render(self.camera)
end

function GetDistance(a, b)
    return (math.sqrt(math.pow(math.abs(a.x - b.x), 2) + math.pow(math.abs(a.y - b.y), 2)))
end

function Level:generatePickups()
    local items = {
        'sword', 'bow', 'fire_tome'
    }
    for i, item in pairs(items) do
        local x, y = self:getRandomCoord()
        while not self.map:isSpawnableSpace(x, y) do
            x, y = self:getRandomCoord()
        end
        table.insert(self.pickups, Pickup(item, (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE))
    end
end

function Level:getRandomCoord()
    return math.random(2, self.map.size), math.random(2, self.map.size)
end
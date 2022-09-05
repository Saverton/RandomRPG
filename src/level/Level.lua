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

    self.pickupManager = PickupManager(self)
    self.pickupManager:spawnPickups({'sword', 'bow', 'fire_tome'})

    self.camera = Camera(self.player, self)

    self.npcManager = NPCManager({}, self)

    Timer.every(10, function() return self.enemySpawner:spawnEnemies() end)
end

function Level:getPlayerSpawnSpace()
    local x, y = 11, 11 -- self:getRandomCoord()

    while not self.map:isSpawnableSpace(x, y) do
        x, y = self:getRandomCoord()
    end

    return {x = x, y = y}
end

function Level:update(dt)
    self.map:update(dt)

    self.enemySpawner:update(dt)

    self.npcManager:update(dt)

    self.player:update(dt)

    self.pickupManager:update(dt)

    self.camera:update()
end

function Level:render()
    self.map:render(self.camera)

    self.pickupManager:render(self.camera)

    self.enemySpawner:render(self.camera)

    self.npcManager:render(self.camera)

    self.player:render(self.camera)
end

function Level:getRandomCoord()
    return math.random(2, self.map.size), math.random(2, self.map.size)
end
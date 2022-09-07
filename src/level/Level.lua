--[[
    Level class: combines all elements of a level (map, entities, player, camera, etc.)
    attributes: map, entities, player, camera
    @author Saverton
]]

Level = Class{}

function Level:init(name, map, player, enemySpawner, npcs, pickups)
    self.name = name
    print(self.name)
    self.map = map or Map('my_map', DEFAULT_MAP_SIZE)

    if player == nil then
        player = {}
    end
    if enemySpawner == nil then
        enemySpawner = {}
    end
    
    self.player = Player(player.def or ENTITY_DEFS['player'], self, player.pos or self:getPlayerSpawnSpace(), player.off or {x = PLAYER_SPAWN_X_OFFSET, y = PLAYER_SPAWN_Y_OFFSET})
    self.player.stateMachine = StateMachine({
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['walk'] = function() return PlayerWalkState(self.player, self) end,
        ['interact'] = function() return EntityInteractState(self.player) end
    })
    self.player:changeState('idle')

    self.enemySpawner = EnemySpawner(self, enemySpawner.entities or {}, enemySpawner.entityCap)

    self.pickupManager = PickupManager(self, pickups)

    self.camera = Camera(self.player, self)

    self.npcManager = NPCManager(npcs, self)

    self.flags = {}

    Timer.every(10, function() return self.enemySpawner:spawnEnemies() end)
end

function Level:getPlayerSpawnSpace()
    local x, y = self:getSpawnableCoord()

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

    if #self.flags > 0 then
        self.player:updateFlags(self.flags)
    end
    self.flags = {}
end

function Level:getRandomCoord()
    return math.random(2, self.map.size), math.random(2, self.map.size)
end

function Level:getSpawnableCoord()
    local x, y = self:getRandomCoord()
    while not self.map:isSpawnableSpace(x, y) do
        x, y= self:getRandomCoord()
    end
    return x, y
end

function Level:throwFlags(flags)
    for i, flag in pairs(flags) do
        table.insert(self.flags, flag)
    end
end
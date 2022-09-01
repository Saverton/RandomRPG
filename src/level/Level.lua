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
    self.player:getItem(Weapon('sword', self.player))
    self.player:getItem(Weapon('bow', self.player))
    self.player:getItem(Weapon('fire_tome', self.player))

    self.enemySpawner = enemySpawner or EnemySpawner(self, DEFAULT_ENTITY_CAP)

    self.camera = Camera(self.player, self)

    Timer.every(10, function() return self.enemySpawner:spawnEnemies() end)
end

function Level:getPlayerSpawnSpace()
    local pos = {
        x = PLAYER_SPAWN_X,
        y = PLAYER_SPAWN_Y
    }

    while not self.map:isSpawnableSpace(pos.x, pos.y) do
        pos.x = math.random(2, self.map.size)
        pos.y = math.random(2, self.map.size)
    end

    return pos
end

function Level:update(dt)
    self.map:update(dt)

    self.enemySpawner:update(dt)

    self.player:update(dt)

    self.camera:update()
end

function Level:render()
    self.map:render(self.camera)

    self.enemySpawner:render(self.camera)

    self.player:render(self.camera)
end

function GetDistance(a, b)
    return (math.sqrt(math.pow(math.abs(a.x - b.x), 2) + math.pow(math.abs(a.y - b.y), 2)))
end
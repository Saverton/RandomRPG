--[[
    Level class: combines all elements of a level (map, entities, player, camera, etc.)
    attributes: map, entities, player, camera
    @author Saverton
]]

Level = Class{}

function Level:init(map, player, enemySpawner)
    self.map = map or Map('my_map', DEFAULT_MAP_SIZE)
    
    self.player = player or Player(ENTITY_DEFS['player'], self)
    self.player.stateMachine = StateMachine({
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['walk'] = function() return PlayerWalkState(self.player, self) end
    })
    self.player:changeState('idle')

    self.enemySpawner = enemySpawner or EnemySpawner(self, DEFAULT_ENTITY_CAP)

    self.camera = Camera(self.player, self)

    Timer.every(10, function() return self.enemySpawner:spawnEnemies() end)
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
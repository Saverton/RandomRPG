--[[
    Level class: combines all elements of a level (map, entities, player, camera, etc.)
    attributes: map, entities, player, camera
    @author Saverton
]]

Level = Class{}

function Level:init(map, entities, player)
    self.map = map
    self.entities = entities
    self.entityCap = DEFAULT_ENTITY_CAP
    
    self.player = player
    self.player.stateMachine = StateMachine({
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['walk'] = function() return PlayerWalkState(self.player, self) end
    })
    self.player.stateMachine:change('idle', self.player)
    self.player.level = self

    self.camera = Camera(player, self)

    -- list of entities to remove from the list
    self.entitiesToRemove = {}

    table.insert(self.entities, Enemy(ENTITY_DEFS['goblin'], self, 10 * TILE_SIZE, 10 * TILE_SIZE))
    SpawnEnemies(self, SPAWN_RANGE)
    Timer.every(10, function() return SpawnEnemies(self, SPAWN_RANGE) end)
end

function Level:update(dt)
    self.map:update(dt)

    for i, entity in pairs(self.entities) do
        entity:update(dt, self.entitiesToRemove, i)

        if GetDistance(entity, self.player) > DESPAWN_RANGE then
            table.insert(self.entitiesToRemove, i)
        end
    end

    self.player:update(dt)

    self.camera:update()

    -- remove dead enemies and despawn enemies far away
    for i, index in pairs(self.entitiesToRemove) do
        table.remove(self.entities, index)
    end
    self.entitiesToRemove = {}
end

function Level:render()
    self.map:render(self.camera)

    print(tostring(#self.entities))
    for i, entity in pairs(self.entities) do
        --if Collide(entity, self.camera.cambox) then
            entity:render(self.camera)
        --end
    end

    self.player:render(self.camera)
end

function GetDistance(a, b)
    return (math.sqrt(math.pow(math.abs(a.x - b.x), 2) + math.pow(math.abs(a.y - b.y), 2)))
end
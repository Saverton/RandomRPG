--[[
    Entity Manager: Manages all activity of enemies and other non player combative entities. Has different spawning algorithms based on
    the instance's level type.
    @author Saverton
]]
EntityManager = Class{}

function EntityManager:init(level, definitions, type)
    self.level = level -- reference to the level that owns this EntityManager
    self:getEntities(definitions.entities)
    self.type = type -- the type used to determine spawning
    self.entityCap = definitions.entityCap or DEFAULT_ENTITY_CAP -- the maximum amount of entities that this entity manager can hold, default = 5.
end

-- update each of the entityManager's attributes
function EntityManager:update(dt)
    -- update all entities in the entities table
    for i, entity in pairs(self.entities) do
        entity:update(dt) -- update the entity
        if GetDistance(self.level.player, entity) > DESPAWN_RANGE or entity.currenthp <= 0 then
            table.remove(self.entities, i)  -- remove the entity if it is past the despawn range or dead
        end
    end
end

-- render all the entities
function EntityManager:render(camera)
    for i, entity in pairs(self.entities) do 
        entity:render(camera)
    end
end

-- create and populate the entities table with any entites defined on loading
function EntityManager:getEntities(entities)
    self.entities = {} -- create an empty entities table
    -- populate every predefined entity into the entities table
    for i, entity in ipairs(entities) do
        local thisEntity = Enemy(entity.definitions, self.level, entity.position)
        table.insert(self.entities, thisEntity)
    end
end

-- call the appropriate spawn function
function EntityManager:spawn()
    if self.type == 'overworld' then
        self:spawnInOverworld()
    elseif self.type == 'dungeon' then
        self:spawnInDungeon()
    end
end

-- spawn enemies in the overworld according to biome spawn rates
function EntityManager:spawnInOverworld()
    local map = self.level.map -- reference to the level's map
    local x, y = math.floor(self.level.player.x / TILE_SIZE), math.floor(self.level.player.y / TILE_SIZE) -- player x and y position on tile grid

    -- parse through each tile in spawn range
    for col = math.max(1, x - MAX_SPAWN_RANGE), math.min(map.width, x + MAX_SPAWN_RANGE), 1 do
        for row = math.max(1, y - MAX_SPAWN_RANGE), math.min(map.height, y + MAX_SPAWN_RANGE), 1 do
            if #self.entities > self.entityCap then
                goto stopSpawning -- stop spawning entities if the entity cap has been reached
            end
            local biome = BIOME_DEFS[map.biomeMap[col][row].name] -- reference to biome definitions at this coordinate
            -- tile must be outside of min spawn rance (10), spawn chance must agree with spawn rate of biome, tile must be able to spawn entity.
            if not (math.abs(col - x) <= MIN_SPAWN_RANGE or math.abs(row - y) <= MIN_SPAWN_RANGE) or
                not (math.random() < biome.spawnRate) or not (map.isSpawnableSpace(col, row)) then
                local enemyName = self:chooseRandomEnemy(biome.enemies) -- choose an enemy from this biome's list
                local playerLevel = self.level.player.statLevel.level -- reference to player's statLevel level
                local startLevel = math.random(math.max(1, playerLevel - 2), playerLevel) -- determine the statLevel of this enemy
                local position = {x = (col - 1) * TILE_SIZE, y = (row - 1) * TILE_SIZE, xOffset = 0, yOffset = 0} -- spawning position
                table.insert(self.entities, Enemy(ENTITY_DEFS[enemyName], self.level, position, startLevel, nil)) -- spawn the enemy
            end
        end
    end
    ::stopSpawning::
end

-- choose a random enemy name from a list of enemies, each with their own spawn chance.
function EntityManager:chooseRandomEnemy(list)
    local randomNumber = math.random() -- random number to determine enemy spawn
    local spawnChance = 0 -- the sum of all spawn chances, compared to randomNumber
    for i, enemy in ipairs(list) do
        spawnChance = spawnChance + enemy.spawnChance -- add the new probability to the spawnChance
        if randomNumber < spawnChance then
            return enemy.name
        end
    end
end

-- spawn enemies in a dungeon according to spawner feature positions
function EntityManager:spawnInDungeon()

end

function EntityManager:spawnEnemies()
    local statLevelMax = self.level.player.statLevel.level or 1
    local map = self.level.map
    local x, y = 

    if #self.entities >= self.entityCap then
        goto stop
    end

    for col = math.max(1, x - SPAWN_MAX_RANGE), math.min(map.size, x + SPAWN_MAX_RANGE), 1 do
        for row = math.max(1, y -  SPAWN_MAX_RANGE), math.min(map.size, y + SPAWN_MAX_RANGE), 1 do
            if self.level.map.featureMap[col][row] ~= nil and FEATURE_DEFS[self.level.map.featureMap[col][row].name].spawner and self.level.map.featureMap[col][row].active then
                self.level.map.featureMap[col][row].active = false
                local entity = Enemy(
                    ENTITY_DEFS[self.level.map.featureMap[col][row].enemy],
                    self.level,
                    {x = (col), y = (row), ox = 0, oy = 0},
                    math.max(1, statLevelMax - math.random(0, 2))
                )
                entity.stateMachine = StateMachine({
                    ['idle'] = function() return EnemyIdleState(entity) end,
                    ['walk'] = function() return EnemyWalkState(entity, self.level) end,
                    ['interact'] = function() return EntityInteractState(entity) end
                })
                entity:changeState('idle')
                table.insert(self.entities, entity)
                goto continue
            end
            if not (map:isSpawnableSpace(col, row)) or
                GetDistance(self.level.player, {x = col * TILE_SIZE, y = row * TILE_SIZE}) < SPAWN_MIN_RANGE * TILE_SIZE then
                goto continue
            end
            local biome = map.biomeMap[col][row]
            if #BIOME_DEFS[biome.name].enemies >= 1 and math.random() < BIOME_DEFS[biome.name].spawnRate then
                local num = math.random()
                local sum = 0
                for i, enemy in pairs(BIOME_DEFS[biome.name].enemies) do
                    sum = sum + enemy.proc 
                    if num < sum then
                        local entity = Enemy(
                            ENTITY_DEFS[enemy.name],
                            self.level,
                            {x = (col), y = (row), ox = 0, oy = 0},
                            math.max(1, statLevelMax - math.random(0, 2))
                        )
                        entity.stateMachine = StateMachine({
                            ['idle'] = function() return EnemyIdleState(entity) end,
                            ['walk'] = function() return EnemyWalkState(entity, self.level) end,
                            ['interact'] = function() return EntityInteractState(entity) end
                        })
                        entity:changeState('idle')
                        table.insert(self.entities, entity)
                        break
                    end
                end
            end

            if #self.entities >= self.entityCap then
                goto stop
            end
            ::continue::
        end
    end

    ::stop::
end

function EntityManager:reset()
    self.entities = {}
    self:spawnEnemies()
end
--[[
    Entity Manager: Manages all activity of enemies and other non player combative entities. Has different spawning algorithms based on
    the instance's level type.
    @author Saverton
]]
EntityManager = Class{}

function EntityManager:init(level, definitions, type)
    self.level = level -- reference to the level that owns this EntityManager
    self:getEntities(definitions.entities or {})
    self.type = type -- the type used to determine spawning
    self.entityCap = definitions.entityCap or DEFAULT_ENTITY_CAP -- the maximum amount of entities that this entity manager can hold, default = 5.
    self:spawn() -- try to spawn enemies
    self.spawnTimer = {} -- timers for the entity manager
    self.removeList = {} -- list of entities to be removed at any given frame
    if type == 'overworld' then
        Timer.every(10, function() self:spawn() end):group(self.spawnTimer) -- try to spawn enemies every 10 seconds
    end
end

-- update each of the entityManager's attributes
function EntityManager:update(dt)
    Timer.update(dt, self.spawnTimer) -- update the spawn timer
    for i, entity in pairs(self.entities) do -- update all entities in the entities table
        entity:update(dt) -- update the entity
        if GetDistance(self.level.player, entity) > DESPAWN_RANGE then
            if not Contains(self.removeList, i) then -- avoid adding already existing entities into the list
                table.insert(self.removeList, i)
            end
        end
    end
    if #self.removeList > 0 then
        self:removeEntitiesFromList() -- remove entities if there are entities to remove
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
        local thisEntity = Enemy(self.level, entity.definitions, {position = entity.position, hasKey = entity.hasKey}, self)
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
            if not (math.abs(col - x) <= MIN_SPAWN_RANGE or math.abs(row - y) <= MIN_SPAWN_RANGE) and
                (math.random() < biome.spawnRate and map:isSpawnableSpace(col, row)) then
                self:spawnRandomEnemy(biome.enemies, col, row) -- choose an enemy from this biome's list
            end
        end
    end
    ::stopSpawning::
end

-- choose a random enemy name from a list of enemies, each with their own spawn chance.
function EntityManager:spawnRandomEnemy(list, col, row)
    local randomNumber = math.random() -- random number to determine enemy spawn
    local spawnChance = 0 -- the sum of all spawn chances, compared to randomNumber
    for i, enemy in ipairs(list) do
        spawnChance = spawnChance + enemy.spawnChance -- add the new probability to the spawnChance
        if randomNumber < spawnChance then
            self:spawnEnemy(enemy.name, col, row)
        end
    end
end

-- spawn an enemy given an enemy name at a coordinate col, row
function EntityManager:spawnEnemy(enemyName, col, row, hasKey)
    local position = {x = col, y = row, xOffset = -1 * ENTITY_DEFS[enemyName].xOffset, yOffset = -1 * ENTITY_DEFS[enemyName].yOffset} -- spawning position
    table.insert(self.entities, Enemy(self.level, ENTITY_DEFS[enemyName], {position = position, hasKey = hasKey}, self)) -- spawn the enemy
end

-- spawn enemies in a dungeon according to spawner feature positions
function EntityManager:spawnInDungeon()
    local map = self.level.map -- reference to the level's map
    local camera = self.level.camera -- reference to the level's camera, which defines the bounds for spawning enemies
    -- parse through each feature in the camera's bounds.
    for col = math.max(1, math.floor(camera.cambox.x / TILE_SIZE)), math.min(map.width, math.floor((camera.cambox.x + camera.cambox.width) / TILE_SIZE)), 1 do
        for row = math.max(1, math.floor(camera.cambox.y / TILE_SIZE)), math.min(map.height, math.floor((camera.cambox.y + camera.cambox.height) / TILE_SIZE)), 1 do
            local feature = map.featureMap[col][row] -- the feature at this index
            if (feature ~= nil) and (FEATURE_DEFS[feature.name].spawner) and (feature.active) then -- feature must be an active spawner
                self:spawnEnemy(feature.enemy, col, row, (math.random(5) == 1)) -- spawn the spawner's enemy, 1 / 5 chance of key
            end
        end
    end
end

-- clear the entity table then call the spawn function again, used when moving through rooms in a dungeon.
function EntityManager:reset()
    self.entities = {} -- clear entity table
    self:spawn() -- spawn new entities
end

-- remove any inactive entities from the entity manager
function EntityManager:removeInactiveEntities()
    for i, entity in ipairs(self.entities) do
        if not entity.active then
            table.insert(self.removeList, i) -- add index to list
        end
    end
end

-- remove all entities from the removal list of indexes
function EntityManager:removeEntitiesFromList()
    for i, index in ipairs(self.removeList) do
        table.remove(self.entities, index) -- remove entity from entity table
    end
    self.removeList = {} -- reset table
end
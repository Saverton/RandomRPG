--[[
    Entity Manager: Manages all activity of enemies and other non player combative entities. Has different spawning algorithms based on
    the instance's level type.
    @author Saverton
]]
EntityManager = Class{}

function EntityManager:init(level, definitions, type)
    self.level = level -- reference to the level that owns this EntityManager
    print_r(definitions.entities)
    self:getEntities(definitions.entities or {})
    self.type = type -- the type used to determine spawning
    self.entityCap = definitions.entityCap or DEFAULT_ENTITY_CAP -- the maximum amount of entities that this entity manager can hold, default = 5.
    self:spawn() -- try to spawn enemies
    if type == 'overworld' then
        Timer.every(10, function() self:spawn() end) -- try to spawn enemies every 10 seconds
    end
end

-- update each of the entityManager's attributes
function EntityManager:update(dt)
    -- update all entities in the entities table
    for i, entity in pairs(self.entities) do
        entity:update(dt) -- update the entity
        if GetDistance(self.level.player, entity) > DESPAWN_RANGE or entity.currentStats.hp <= 0 then
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
        local thisEntity = Enemy(self.level, entity.definitions, entity.position)
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
function EntityManager:spawnEnemy(enemyName, col, row)
    local position = {x = col, y = row, xOffset = 0, yOffset = 0} -- spawning position
    table.insert(self.entities, Enemy(self.level, ENTITY_DEFS[enemyName], position)) -- spawn the enemy
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
                self:spawnEnemy(feature.enemy, col, row) -- spawn the spawner's enemy
            end
        end
    end
end

-- clear the entity table then call the spawn function again, used when moving through rooms in a dungeon.
function EntityManager:reset()
    self.entities = {} -- clear entity table
    self:spawn() -- spawn new entities
end
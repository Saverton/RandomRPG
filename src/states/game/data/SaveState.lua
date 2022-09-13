--[[
    State in which the game is saved.
    @author Saverton
]]

SaveState = Class{__includes = BaseState}

function SaveState:init(level, loadnext)
    self.worldName = level.worldName -- name of the world save
    self.levelName = level.levelName -- name of the level being saved
    self.levelType = string.sub(self.levelName, 0, string.find(self.levelName, "-")) -- type of the level being saved
    self.map = level.map -- map in the level being saved
    self.player = level.player -- player in the level being saved
    self.entityManager = level.entityManager -- entityManager being saved
    self.pickupManager = level.pickupManager -- pickupManager being saved
    self.npcManager = level.npcManager -- npcManager being saved
    self.loadnext = loadnext or nil -- next level to load on completion of save
end

function SaveState:update()
    self:saveGame() -- save the game
    gStateStack:pop() -- drop the save state
    if self.loadnext ~= nil then -- load a new world if set to load next
        gStateStack:pop() -- destroy existing world
        gStateStack:push(LoadState('worlds/' .. self.worldName, self.loadnext)) -- load new world
    end
end

-- render the save state screen
function SaveState:render()
    love.graphics.setColor(0, 0, 0.5, 1)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function SaveState:saveGame()
    love.filesystem.setIdentity('random_rpg') -- set the save file destination
    if not love.filesystem.getInfo('worlds/' .. self.worldName .. '/' .. self.levelName) then
        love.filesystem.createDirectory('worlds/' .. self.worldName .. '/' .. self.levelName) -- save the world's map
    end
    self:saveMap('worlds/' .. self.worldName .. '/' .. self.levelName)
    self:savePlayer('worlds/' .. self.worldName)
    self:saveEntities('worlds/' .. self.worldName .. '/' .. self.levelName)
    self:savePickups('worlds/' .. self.worldName .. '/' .. self.levelName)
    if self.levelType == 'overworld' then
        self:saveNPCS('worlds/' .. self.worldName .. '/' .. self.levelName)
    end
end

-- save a map
function SaveState:saveMap(path)
    local featureMap = {}
    local tileMap = {}
    local gatewayMap = {}
    local spawnerMap = {}
    local start = self.map.start
    for col = 1, self.map.width, 1 do
        featureMap[col] = {}
        for row = 1, self.map.height, 1 do
            local feature = self.map.featureMap[col][row]
            if feature ~= nil then
                featureMap[col][row] = feature.name
                if FEATURE_DEFS[feature.name].gateway then
                    table.insert(gatewayMap, {name = feature.name, destination = feature.destination, x = col, y = row})
                elseif FEATURE_DEFS[feature.name].spawner then
                    table.insert(spawnerMap, {name = feature.name, enemy = feature.enemy, x = col, y = row})
                end
            end
        end
    end
    for i, col in ipairs(self.map.tileMap) do
        tileMap[i] = {}
        for j, tile in ipairs(col) do
            tileMap[i][j] = tile.name
        end
    end
    love.filesystem.write(path .. '/world_features.lua', Serialize(featureMap))
    love.filesystem.write(path .. '/world_tiles.lua', Serialize(tileMap))
    love.filesystem.write(path .. '/world_gateways.lua', Serialize(gatewayMap))
    if self.levelType == 'overworld' then
        local playerPosition = {x = self.player.x, y = self.player.y} -- player's position saved if it is overworld
        local biomeMap = {} -- empty biome map
        for i, col in ipairs(self.map.biomeMap) do
            biomeMap[i] = {}
            for j, biome in ipairs(col) do
                biomeMap[i][j] = biome.name
            end
        end
        love.filesystem.write(path .. '/world_biomes.lua', Serialize(biomeMap))
        love.filesystem.write(path .. '/player_position.lua', Serialize(playerPosition))
    elseif self.levelType == 'dungeon' then
        love.filesystem.write(path .. '/world_spawners.lua', Serialize(spawnerMap))
        love.filesystem.write(path .. '/start.lua', Serialize(start))
    end
end

-- save a player
function SaveState:savePlayer(path)
    local position = {
        x = (self.player.x / 16) + 1, y = (self.player.y / 16) + 1, xOffset = PLAYER_SPAWN_X_OFFSET, yOffset = PLAYER_SPAWN_Y_OFFSET
    }
    local definitions = {
        name = self.player.name,
        animationName = self.player.animationName,
        width = self.player.width,
        height = self.player.height,
        xOffset = self.player.xOffset,
        yOffset = self.player.yOffset,
        money = self.player.money,
        combatStats = self.player.combatStats,
        boosts = self.player.boosts,
        currentStats = self.player.currentStats,
        speed = self.player.speed,
        quests = {},
        effectManager = self.player.effectManger:getSaveData(),
        items = {},
        statLevel = self.player.statLevel:getSaveData()
    }
    local items = {}
    local quests = {}
    for i, item in ipairs(self.player.items) do
        table.insert(items, {name = item.name, quantity = item.quantity})
    end
    definitions.items = items
    for i, quest in ipairs(self.player.quests) do
        table.insert(quests, {name = quest.name, flags = quest.flags})
    end
    definitions.quests = quests
    local player = {definitions = definitions, position = position, currentLevel = self.levelName} -- create player table holding all player data
    love.filesystem.write(path .. '/player.lua', Serialize(player))
end

-- save all entities
function SaveState:saveEntities(path)
    local entityManager = {
        entities = {},
        entityCap = self.entityManager.entityCap
    }

    for i, entity in ipairs(self.enemySpawner.entities) do
        local position = {
            x = (entity.x / 16) + 1, y = (entity.y / 16) + 1, xOffset = 0, yOffset = 0
        }
    
        local definitions = {
            name = entity.name,
            animationName = entity.animationName,
            width = entity.width,
            height = entity.height,
            xOffset = entity.xOffset,
            yOffset = entity.yOffset,
            combatStats = entity.combatStats,
            speed = entity.speed,
            boosts = entity.boosts,
            currentStats = entity.currentStats,
            effectManager = entity.effectManager:getSaveData(),
            items = {},
            aggressiveDistance = entity.aggressiveDistance,
            color = entity.color,
            statLevel = entity.statLevel:getSaveData()
        }
        local items = {}
        for k, item in ipairs(entity.items) do
            table.insert(items, {name = item.name, quantity = item.quantity})
        end
        definitions.items = items
        local entityTable = {definitions = definitions, position = position}
        table.insert(entityManager.entities, entityTable)
    end
    love.filesystem.write(path .. '/entities.lua', Serialize(entityManager))
end

function SaveState:saveNPCS(path)
    local npcs = {}
    for i, entity in ipairs(self.npcManager.npcs) do
        local position = {
            x = (entity.x / 16) + 1, y = (entity.y / 16) + 1, xOffset = 0, yOffset = 0
        }
        local definitions = {
            name = entity.name,
            animationName = entity.animationName,
            npcName = entity.npcName,
            width = entity.width,
            height = entity.height,
            xOffset = entity.xOffset,
            yOffset = entity.yOffset,
            speed = entity.speed,
            timesInteractedWith = entity.timesInteractedWith,
            shop = {},
            quest = {},
            hasQuest = NPC_DEFS[entity.name].hasQuest
        }
        if entity.shop ~= nil then
            definitions.shop = entity.shop:getSaveData()
        elseif entity.quest ~= nil then
            definitions.quest = entity.quest:getSaveData()
        end
        local entityTable = {definitions = definitions, position = position}
        table.insert(npcs, entityTable)
    end
    love.filesystem.write(path .. '/npcs.lua', Serialize(npcs))
end

function SaveState:savePickups(path)
    local pickups = {}
    for i, pickup in ipairs(self.pickupManager.pickups) do
        table.insert(pickups, pickup) -- add each pickup to the save file
    end
    love.filesystem.write(path .. '/pickups.lua', Serialize(pickups))
end
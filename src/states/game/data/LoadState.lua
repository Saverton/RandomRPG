--[[
    Load state: load the world in from a specific path.
    @author Saverton
]]

LoadState = Class{__includes = BaseState}
 
function LoadState:init(path, loadLevel)
    love.filesystem.setIdentity('random_rpg')
    self.path = path -- file path to world
    self.loadLevel = loadLevel or nil -- level to be loaded
    self.level = nil -- level that is loaded
end

function LoadState:update(dt)
    self.level = self:loadWorld() -- load the world
    gStateStack:pop()
    gStateStack:push(WorldState({
        level = self.level
    })) -- create the level
    gStateStack:push(DivergePointState({x = self.level.player.x + self.level.player.width / 2 - self.level.camera.x, 
        y = self.level.player.y + self.level.player.height / 2 - self.level.camera.y}, {0, 0, 0, 1}, 1.5)) -- diverge point state to introduce the world
end

-- render a dark green screen for loading
function LoadState:render()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function LoadState:loadWorld()
    local worldName = string.sub(self.path, 8, string.len(self.path))
    local player = self:loadPlayer()
    if self.loadLevel == nil then
        self.loadLevel = player.currentLevel or 'overworld-1'
    end
    self.path = self.path .. '/' .. self.loadLevel -- set path to level specific
    self.levelType = string.sub(self.loadLevel, 0, string.find(self.loadLevel, "-")) -- type of the level being saved
    if not love.filesystem.getInfo(self.path) then
        if self.levelType == 'overworld' then
            return Overworld(worldName, self.loadLevel, {player = player})
        elseif self.levelType == 'dungeon' then
            return Dungeon(worldName, self.loadLevel, {player = player})
        end
    end
    local map = self:loadMap()
    local entityManager = self:loadEntities()
    local pickupManager = self:loadPickups()
    if self.levelType == 'overworld' then
        local playerPosition = loadstring(love.filesystem.read(self.path .. '/player_position.lua'))()
        player.position.x, player.position.y = math.floor(playerPosition.x / TILE_SIZE), math.floor(playerPosition.y / TILE_SIZE)
        local npcManager = self:loadNPCS()
        return Overworld(worldName, self.loadLevel, {map = map, player = player, entityManager = entityManager, 
            npcManager = npcManager, pickupManager = pickupManager}) -- create an overworld
    elseif self.levelType == 'dungeon' then
        return Dungeon(worldName, self.loadLevel, {map = map, player = player, entityManager = entityManager, 
        pickupManager = pickupManager}) -- create a dungeon
    end
end

-- load a map
function LoadState:loadMap()
    local tileMap = loadstring(love.filesystem.read(self.path .. '/world_tiles.lua'))()
    for i, col in ipairs(tileMap) do
        for j, tile in ipairs(col) do
            tileMap[i][j] = Tile(tile)
        end
    end
    local width, height = #tileMap, #tileMap[1]
    local featureMap = loadstring(love.filesystem.read(self.path .. '/world_features.lua'))()
    local gatewayMap = loadstring(love.filesystem.read(self.path .. '/world_gateways.lua'))()
    for col = 1, width, 1 do
        for row = 1, height, 1 do
            if featureMap[col][row] ~= nil then
                if FEATURE_DEFS[featureMap[col][row]].animated then
                    featureMap[col][row] = AnimatedFeature(featureMap[col][row], Animation(featureMap[col][row], 'main'))
                else
                    featureMap[col][row] = Feature(featureMap[col][row])
                end
            end
        end
    end
    if self.levelType == 'overworld' then
        local biomeMap = loadstring(love.filesystem.read(self.path .. '/world_biomes.lua'))()
        for i, col in ipairs(biomeMap) do
            for j, biome in ipairs(col) do
                biomeMap[i][j] = Biome(biome)
            end
        end
        return OverworldMap({width = width, height = height}, {biomeMap = biomeMap, tileMap = tileMap, featureMap = featureMap, gatewayMap = gatewayMap})
    elseif self.levelType == 'dungeon' then
        local spawnerMap = loadstring(love.filesystem.read(self.path .. '/world_spawners.lua'))()
        local start = loadstring(love.filesystem.read(self.path .. '/start.lua'))()
        return DungeonMap({width = width, height = height}, {tileMap = tileMap, featureMap = featureMap, gatewayMap = gatewayMap, start = start, spawnerMap = spawnerMap})
    end
end

function LoadState:loadPlayer()
    return loadstring(love.filesystem.read(self.path .. '/player.lua'))()
end

function LoadState:loadEntities()
    return loadstring(love.filesystem.read(self.path .. '/entities.lua'))()
end

function LoadState:loadNPCS()
    return loadstring(love.filesystem.read(self.path .. '/npcs.lua'))()
end

function LoadState:loadPickups()
    return loadstring(love.filesystem.read(self.path .. '/pickups.lua'))()
end
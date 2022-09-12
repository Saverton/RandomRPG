--[[
    Load state: load the world in from a specific path.
    @author Saverton
]]

LoadState = Class{__includes = BaseState}
 
function LoadState:init(path, loadLevel)
    love.filesystem.setIdentity('random_rpg')
    self.path = path
    self.loadLevel = loadLevel or nil
    self.level = nil
end

function LoadState:update(dt)
    self.level = self:loadWorld()

    gStateStack:pop()
    gStateStack:push(WorldState({
        level = self.level
    }))
    gStateStack:push(DivergePointState({x = self.level.player.x + self.level.player.width / 2 - self.level.camera.x, 
        y = self.level.player.y + self.level.player.height / 2 - self.level.camera.y}, {0, 0, 0, 1}, 1.5))
end

function LoadState:render()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function LoadState:loadWorld()
    local worldName = string.sub(self.path, 8, string.len(self.path))
    local map = nil
    local player = nil
    local enemySpawner = nil
    local npcManager = nil
    local pickupManager = nil

    player = self:loadPlayer()
    if self.loadLevel == nil then
        self.loadLevel = player.currentLevel or 'overworld-1'
    end
    self.path = self.path .. '/' .. self.loadLevel
    if not love.filesystem.getInfo(self.path) then
        return (Level(worldName, self.loadLevel, nil, player))
    end
    
    local playerPos = loadstring(love.filesystem.read(self.path .. '/player_pos.lua'))()
    player.pos.x = math.floor(playerPos.x / TILE_SIZE)
    player.pos.y = math.floor(playerPos.y / TILE_SIZE)

    map = self:loadMap()
    enemySpawner = self:loadEntities()
    npcManager = self:loadNPCS()
    pickupManager = self:loadPickups()

    return Level(worldName, self.loadLevel, map, player, enemySpawner, npcManager, pickupManager)
end

function LoadState:loadMap()
    local tileMap = loadstring(love.filesystem.read(self.path .. '/world_tiles.lua'))()
    local biomeMap = loadstring(love.filesystem.read(self.path .. '/world_biomes.lua'))()

    for i, col in ipairs(tileMap) do
        for j, tile in ipairs(col) do
            tileMap[i][j] = Tile(tile)
        end
    end

    for i, col in ipairs(biomeMap) do
        for j, biome in ipairs(col) do
            biomeMap[i][j] = Biome(biome)
        end
    end

    local size = #tileMap 
    local featureMap = loadstring(love.filesystem.read(self.path .. '/world_features.lua'))()
    local gatewayMap = loadstring(love.filesystem.read(self.path .. '/world_gateways.lua'))()
    local spawnerMap = loadstring(love.filesystem.read(self.path .. '/world_spawners.lua'))()
    local startSpace = loadstring(love.filesystem.read(self.path .. '/start_space.lua'))()

    for col = 1, size, 1 do
        for row = 1, size, 1 do
            if featureMap[col][row] ~= nil then
                if FEATURE_DEFS[featureMap[col][row]].spawner then
                elseif FEATURE_DEFS[featureMap[col][row]].animated then
                    featureMap[col][row] = AnimatedFeature(featureMap[col][row], Animation(featureMap[col][row], 'main'))
                else
                    featureMap[col][row] = Feature(featureMap[col][row])
                end
            end
        end
    end

    return Map(self.loadLevel, size, tileMap, biomeMap, featureMap, gatewayMap, spawnerMap, startSpace)
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
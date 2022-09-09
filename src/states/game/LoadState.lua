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
end

function LoadState:render()
    love.graphics.setColor(0, 0.5, 0, 1)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Loading...', VIRTUAL_WIDTH / 2 - 30, VIRTUAL_HEIGHT / 2 - 10, 60, 'center')
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('Loading...', VIRTUAL_WIDTH / 2 - 30 + 1, VIRTUAL_HEIGHT / 2 - 10 + 1, 60, 'center')
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
        self.loadLevel = player.currentLevel or 'map_overworld'
    end
    print('load level 2 = ' .. self.loadLevel)
    self.path = self.path .. '/' .. self.loadLevel
    if not love.filesystem.getInfo(self.path) then
        return (Level(worldName, self.loadLevel, nil, player))
    end

    map = self:loadMap()
    enemySpawner = self:loadEntities()
    npcManager = self:loadNPCS()
    pickupManager = self:loadPickups()

    return Level(worldName, self.loadLevel, map, player, enemySpawner, npcManager, pickupManager)
end

function LoadState:loadMap()
    local tiles = loadstring(love.filesystem.read(self.path .. '/world_tiles.lua'))()
    local biomes = loadstring(love.filesystem.read(self.path .. '/world_biomes.lua'))()

    for i, col in ipairs(tiles) do
        for j, tile in ipairs(col) do
            tiles[i][j] = Tile(tile, i, j)
        end
    end

    for i, col in ipairs(biomes) do
        for j, biome in ipairs(col) do
            biomes[i][j] = Biome(biome)
        end
    end

    local size = #tiles 
    local tileMap = TileMap(size, tiles, biomes)
    local featureMap = loadstring(love.filesystem.read(self.path .. '/world_features.lua'))()
    local gatewayMap = loadstring(love.filesystem.read(self.path .. '/world_gateways.lua'))()

    for col = 1, size, 1 do
        for row = 1, size, 1 do
            if featureMap[col][row] ~= nil then
                if FEATURE_DEFS[featureMap[col][row]].animated then
                    featureMap[col][row] = AnimatedFeature(featureMap[col][row], col, row, Animation(featureMap[col][row], 'main'))
                else
                    featureMap[col][row] = Feature(featureMap[col][row], col, row)
                end
            end
        end
    end

    return Map(self.loadLevel, size, tileMap, featureMap, gatewayMap)
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
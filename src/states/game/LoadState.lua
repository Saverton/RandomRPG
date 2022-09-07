--[[
    Load state: load the world in from a specific path.
    @author Saverton
]]

LoadState = Class{__includes = BaseState}
 
function LoadState:init(path, debug)
    love.filesystem.setIdentity('random_rpg')
    self.path = path
    self.level = nil
end

function LoadState:update(dt)
    self.level = self:loadWorld()

    gStateStack:pop()
    gStateStack:push(WorldState({
        level = self.level, 
        debug = debug
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
    local map = nil
    local player = nil

    map = self:loadMap()
    player = self:loadPlayer()

    return Level(map, player)
end

function LoadState:loadMap()
    local tiles = loadstring(love.filesystem.read(self.path .. '/map_overworld/world_tiles.lua'))()
    local biomes = loadstring(love.filesystem.read(self.path .. '/map_overworld/world_biomes.lua'))()

    for i, col in ipairs(tiles) do
        for j, tile in ipairs(col) do
            tiles[i][j] = Tile(tile, i, j)
        end
    end

    for i, col in ipairs(biomes) do
        for j, biome in ipairs(col) do
            biomes[i][j] = Biome(BIOME_DEFS[biome])
        end
    end

    local size = #tiles 
    local tileMap = TileMap(size, tiles, biomes)
    local featureMap = loadstring(love.filesystem.read(self.path .. '/map_overworld/world_features.lua'))()

    
    for col = 1, size, 1 do
        for row = 1, size, 1 do
            if featureMap[col][row] ~= nil then
                featureMap[col][row] = Feature(featureMap[col][row], col, row)
            end
        end
    end

    return Map('map', size, tileMap, featureMap)
end

function LoadState:loadPlayer()
    return loadstring(love.filesystem.read(self.path .. '/player.lua'))()
end
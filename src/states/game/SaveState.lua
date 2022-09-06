--[[
    State in which the game is saved.
    @author Saverton
]]

SaveState = Class{__includes = BaseState}

function SaveState:init(level)
    print('save state loaded')
    self.name = level.name
    self.map = level.map
end

function SaveState:update()
    self:saveGame()

    gStateStack:pop()
    gStateStack:pop()
end

function SaveState:render()
    love.graphics.setColor(0, 0, 0.5, 1)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Saving...', VIRTUAL_WIDTH / 2 - 30, VIRTUAL_HEIGHT / 2 - 10, 60, 'center')
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('Saving...', VIRTUAL_WIDTH / 2 - 30 + 1, VIRTUAL_HEIGHT / 2 - 10 + 1, 60, 'center')
end

function SaveState:saveGame()
    love.filesystem.setIdentity('random_rpg')

    -- save the world's map
    if not love.filesystem.getInfo('worlds/' .. self.name .. '/map_overworld') then
        love.filesystem.createDirectory('worlds/' .. self.name .. '/map_overworld')
    end

    self:saveMap('worlds/' .. self.name .. '/map_overworld')
end

function SaveState:saveMap(path)
    local featureMap = {}
    local tilesMap = {}
    local biomeMap = {}

    for col = 1, self.map.size, 1 do
        featureMap[col] = {}
        for row = 1, self.map.size, 1 do
            local feature = self.map.featureMap[col][row]
            if feature ~= nil then
                featureMap[col][row] = feature.name
            end
        end
    end

    for i, col in ipairs(self.map.tileMap.tiles) do
        tilesMap[i] = {}
        for j, tile in ipairs(col) do
            tilesMap[i][j] = tile.name
        end
    end

    for i, col in ipairs(self.map.tileMap.biomes) do
        biomeMap[i] = {}
        for j, biome in ipairs(col) do
            biomeMap[i][j] = biome.name
        end
    end

    love.filesystem.write(path .. '/world_features.lua', Serialize(featureMap))
    love.filesystem.write(path .. '/world_tiles.lua', Serialize(tilesMap))
    love.filesystem.write(path .. '/world_biomes.lua', Serialize(biomeMap))
end
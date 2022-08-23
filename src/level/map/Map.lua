--[[
    Map Class: contains the map on which the game is played
    attributes: name, size, tileMap, featureMap
    @author Saverton
]]

Map = Class{}

function Map:init(name, size, tileMap, featureMap)
    self.name = name or nil
    --size dimension of map
    self.size = size or DEFAULT_MAP_SIZE
    self.tileMap = tileMap
    self.featureMap = featureMap
end

function Map:update(dt)
    -- update features
    for i, row in pairs(self.featureMap) do
        for j, feature in pairs(row) do
            feature:update(dt)
        end
    end
end

function Map:render(camera)
    local xStart = math.floor(camera.cambox.x / TILE_SIZE)
    local xEnd = math.floor(camera.cambox.x + camera.cambox.width / TILE_SIZE)
    local yStart = math.floor(camera.cambox.y / TILE_SIZE)
    local yEnd = math.floor(camera.cambox.y + camera.cambox.height / TILE_SIZE)

    -- render tiles
    
    for row = xStart, xEnd, 1 do
        for col = yStart, yEnd, 1 do
            self.tileMap.tiles[row][col]:render(camera.x, camera.y)
        end
    end

    -- render features
    for row = xStart, xEnd, 1 do
        for col = yStart, yEnd, 1 do
            self.featureMap[row][col]:render(camera.x, camera.y)
        end
    end
end
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

function Map:render()
    -- render tiles
    for i, row in pairs(self.tileMap) do
        for j, tile in pairs(row) do
            tile:maprender()
        end
    end

    -- render features
    for i, row in pairs(self.featureMap) do
        for j, feature in pairs(row) do
            feature:render()
        end
    end
end
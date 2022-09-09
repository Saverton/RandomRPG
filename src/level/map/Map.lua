--[[
    Map Class: contains the map on which the game is played
    attributes: name, size, tileMap, featureMap
    @author Saverton
]]

Map = Class{}

function Map:init(name, size, tileMap, featureMap, gatewayMap)
    self.name = name or nil
    --size dimension of map
    self.size = size or DEFAULT_MAP_SIZE
    self.tileMap = tileMap or TileMap(self.size)
    self.featureMap = featureMap or GenerateFeatures(self.size, self.tileMap)
    self.animatedFeatures = GetAnimatedFeatures(self.featureMap)
    GenerateFortress(self.featureMap, self.size, self.name)

    for i, gateway in ipairs(gatewayMap or {}) do
        self.featureMap[gateway.x][gateway.y] = GatewayFeature(gateway.name, gateway.x, gateway.y, gateway.destination, gateway.active)
    end
end

function Map:update(dt)
    self.tileMap:update(dt) 

    -- update feature animations
    for i, feature in pairs(self.animatedFeatures) do
        feature:update(dt)
    end
    -- update features
    for i, col in pairs(self.featureMap) do
        for j, feature in pairs(col) do
            feature:update(dt)
        end
    end
end

function Map:render(camera)
    local xStart = math.floor(camera.cambox.x / TILE_SIZE)
    local xEnd = math.floor((camera.cambox.x + camera.cambox.width) / TILE_SIZE)
    local yStart = math.floor(camera.cambox.y / TILE_SIZE)
    local yEnd = math.floor((camera.cambox.y + camera.cambox.height) / TILE_SIZE)

    -- render tiles
    
    for col = math.max(1, xStart), math.min(self.size, xEnd), 1 do
        for row = math.max(1, yStart), math.min(self.size, yEnd), 1 do
            self.tileMap.tiles[col][row]:render(camera.x, camera.y)
            for i, edge in pairs (self.tileMap.edges[col][row]) do
                love.graphics.draw(gTextures['edges'], gFrames['edges'][edge], ((col - 1) * TILE_SIZE - camera.x), ((row - 1) * TILE_SIZE - camera.y))
            end
        end
    end

    -- render features

    for col = math.max(1, xStart), math.min(self.size, xEnd), 1 do
        for row = math.max(1, yStart), math.min(self.size, yEnd), 1 do
            local feat = self.featureMap[col][row]
            if feat ~= nil then
                feat:render(camera.x, camera.y)
            end
        end
    end
end

function Map:isSpawnableSpace(col, row)
    return not (self.tileMap.tiles[col][row].barrier or (self.featureMap[col][row] ~= nil and FEATURE_DEFS[self.featureMap[col][row].name].isSolid))
end
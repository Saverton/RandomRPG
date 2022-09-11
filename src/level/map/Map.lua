--[[
    Map Class: contains the map on which the game is played
    attributes: name, size, tileMap, featureMap
    @author Saverton
]]

Map = Class{}

function Map:init(name, size, tileMap, biomeMap, featureMap, gatewayMap)
    self.name = name or nil
    self.size = size or DEFAULT_MAP_SIZE
    self.tileAnimators = {
        ['water'] = Animation('water', 'main')
    }
    self.biomeMap = biomeMap
    self.tileMap = tileMap
    -- set any animated tiles to the tileAnimator provided
    self:linkAnimatedTiles()
    self.edges = MapGenerator.generateEdges(size, self.tileMap) 
    self.featureMap = featureMap
    -- get a list of animated features to keep as a reference for updating animations
    self.animatedFeatures = MapGenerator.getAnimatedFeatures(self.featureMap)
    
    -- make sure any gateways that haven't been properly initiated are initiated
    for i, gateway in ipairs(gatewayMap or {}) do
        self.featureMap[gateway.x][gateway.y] = GatewayFeature(gateway.name, gateway.destination, gateway.active)
    end
end

function Map:update(dt)
    -- update any tile animations
    for i, animator in pairs (self.tileAnimators) do
        animator:update(dt)
    end

    -- update feature animations
    for i, feature in pairs(self.animatedFeatures) do
        feature:update(dt)
    end
end

function Map:render(camera)
    local xStart = math.floor(camera.cambox.x / TILE_SIZE)
    local xEnd = math.floor((camera.cambox.x + camera.cambox.width) / TILE_SIZE)
    local yStart = math.floor(camera.cambox.y / TILE_SIZE)
    local yEnd = math.floor((camera.cambox.y + camera.cambox.height) / TILE_SIZE)

    -- render tiles, edges, and features
    for col = math.max(1, xStart), math.min(self.size, xEnd), 1 do
        for row = math.max(1, yStart), math.min(self.size, yEnd), 1 do
            self.tileMap[col][row]:render(camera.x, camera.y, col, row)
            for i, edge in pairs (self.edges[col][row]) do
                love.graphics.draw(gTextures['edges'], gFrames['edges'][edge], ((col - 1) * TILE_SIZE - camera.x), ((row - 1) * TILE_SIZE - camera.y))
            end
            local feat = self.featureMap[col][row]
            if feat ~= nil then
                feat:render(camera.x, camera.y, col, row)
            end
        end
    end
end

function Map:isSpawnableSpace(col, row)
    return not (TILE_DEFS[self.tileMap[col][row].name].barrier or (self.featureMap[col][row] ~= nil and FEATURE_DEFS[self.featureMap[col][row].name].isSolid))
end

function Map:linkAnimatedTiles()
    for i, col in ipairs(self.tileMap) do
        for j, tile in ipairs(col) do
            if TILE_DEFS[tile.name].animated then
                self.tileMap[i][j] = AnimatedTile(tile.name, self.tileAnimators[tile.name])
            end
        end
    end
end
--[[
    Map Class: manages all activity of the map on which the game is played. This class is never instantiated on its own, but has children
    classes with specific behaviors for the Overworld and Dungeon Maps.
    @author Saverton
]]

Map = Class{}

function Map:init(dimensions, definitions)
    self.width = dimensions.width
    self.height = dimensions.height -- the width and height (in tiles) of the map
    self.tileMap = definitions.tileMap -- tiles that make the base of the world
    self:linkAnimatedTiles() -- set any animated tiles to the tileAnimator provided
    self.featureMap = definitions.featureMap
    self.animatedFeatures = OverworldGenerator.getAnimatedFeatures(self.featureMap) 
        -- get a list of animated features to keep as a reference for updating animations
    -- make sure all gateway features are properly initiated.
    for i, gateway in ipairs(definitions.gatewayMap or {}) do
        self.featureMap[gateway.x][gateway.y] = GatewayFeature(gateway.name, gateway.destination)
    end
end

-- update all map objects
function Map:update(dt)
    -- update all tile animations
    for i, animator in pairs (TILE_ANIMATORS) do
        animator:update(dt)
    end
    -- update all feature animations
    for i, feature in pairs(self.animatedFeatures) do
        feature:update(dt)
    end
end

-- render all map objects
function Map:render(camera)
    local startX, startY, endX, endY = self:getRenderCoordinates(camera) -- get the coordinate bounds for what objects to render.
    -- render tiles and features at each index in the rendering bounds.
    for col = math.max(1, startX), math.min(self.width, endX), 1 do
        for row = math.max(1, startY), math.min(self.height, endY), 1 do
            self.tileMap[col][row]:render(camera.x, camera.y, col, row) -- render the tile at this coordinate
            self:renderFeature(col, row, camera)
        end
    end
end

-- parse through all tiles and set any animated ones to a global constant animator.
function Map:linkAnimatedTiles()
    for i, col in ipairs(self.tileMap) do
        for j, tile in ipairs(col) do
            if TILE_DEFS[tile.name].animated then
                self.tileMap[i][j] = AnimatedTile(tile.name, TILE_ANIMATORS[tile.name])
            end
        end
    end
end

-- returns the start and end x and y coordinates for where to render map objects. return: startX, startY, endX, endY
function Map:getRenderCoordinates(camera)
    return math.floor(camera.cambox.x / TILE_SIZE), math.floor(camera.cambox.y / TILE_SIZE), 
        math.floor((camera.cambox.x + camera.cambox.width) / TILE_SIZE), math.floor((camera.cambox.y + camera.cambox.height) / TILE_SIZE)
end

-- draw a feature at this coordinate if that feature exists
function Map:renderFeature(col, row, camera)
    local feature = self.featureMap[col][row]
    if feature ~= nil then -- ensure that there is a feature here before trying to render it
        feature:render(camera.x, camera.y, col, row)
    end
end

-- return true if the space at this index is considered spawnable, false otherwise.
function Map:isSpawnableSpace(col, row)
    return not (TILE_DEFS[self.tileMap[col][row].name].barrier or (self.featureMap[col][row] ~= nil and FEATURE_DEFS[self.featureMap[col][row].name].isSolid))
end

-- return a spawnable set of random coordinates on the map
function Map:getSpawnableCoord()
    local col, row = math.random(2, self.width - 1), math.random(2, self.height - 1)
    while not self:isSpawnableSpace(col, row) do -- choose random spaces until the space is spawnable
        col, row = math.random(2, self.width - 1), math.random(2, self.height - 1)
    end
    return col, row -- return the coordinate
end

-- constant table with references for animations for any animated Tiles
TILE_ANIMATORS = {
    ['water'] = Animation('water', 'main'),
}
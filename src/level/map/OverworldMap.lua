--[[
    Overworld Map: inherited from Map, has specialized behavior for the overworld. Differences from DungeonMap: has biomeMap, has edge drawing,
    doesn't have spawners, doesn't have start location.
    @author Saverton
]]

OverworldMap = Class{__includes = Map}

function OverworldMap:init(dimensions, definitions)
    Map.init(self, dimensions, definitions) -- initiate the Map's base features
    self.biomeMap = definitions.biomeMap -- initiate the biomeMap, which determines enemy spawning.
    self.edgeMap = OverworldGenerator.generateEdgeMap(self.tileMap, dimensions) -- generate the edge map, which has edges to be drawn over different neighboring tiles
end

-- render all map objects, including edges between different tiles
function OverworldMap:render(camera)
    local startX, startY, endX, endY = self:getRenderCoordinates(camera) -- get the coordinate bounds for what objects to render.
    -- render tiles, edges, and features at each index in the rendering bounds.
    for col = math.max(1, startX), math.min(self.width, endX), 1 do
        for row = math.max(1, startY), math.min(self.height, endY), 1 do
            self.tileMap[col][row]:render(camera.x, camera.y, col, row) -- render the tile at this coordinate
            self:renderEdges(col, row, camera)
            self:renderFeature(col, row, camera)
        end
    end
end

-- render edges around a single tile at position x, y on screen
function OverworldMap:renderEdges(col, row, camera)
    local x = ((col - 1) * TILE_SIZE) - camera.x
    local y = ((row - 1) * TILE_SIZE) - camera.y -- determine the x and y position on screen at which the edges are to be drawn
    for i in pairs(self.edgeMap[col][row]) do
        love.graphics.draw(gTextures['edges'], gFrames['edges'][i], x, y)
    end
end
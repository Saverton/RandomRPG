--[[
    World map is a gui type that takes in a Map object, creates a colored pixel image from that map, and displays it on a panel.
    @author Saverton
]]

WorldMap = Class{}

function WorldMap:init(map, player)
    self.map = self.encodeWorldMap(map)
    local width, height = self.map:getWidth(), self.map:getHeight()
    self.panel = Panel(((VIRTUAL_WIDTH / 2) - (MAP_PADDING + (width / 2))), ((VIRTUAL_HEIGHT / 2) - (MAP_PADDING + (width / 2))), width + (2 * MAP_PADDING), height + (2 * MAP_PADDING))
end

function WorldMap:render()
    self.panel:render()
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Map', self.panel.x, self.panel.y + TEXT_OFFSET, self.panel.width, 'center')
    love.graphics.draw(self.map, love.math.newTransform(self.panel.x + MAP_PADDING, self.panel.y + MAP_PADDING))
    love.graphics.printf("'esc' to close", self.panel.x, self.panel.y + TEXT_OFFSET + MAP_PADDING + self.map:getHeight(), self.panel.width, 'center')
end

function WorldMap.encodeWorldMap(map)
    local mapData = love.image.newImageData(map.width, map.height) -- create a blank image data with the dimensions of the map itself
    for col, column in ipairs(map.tileMap) do
        for row, tile in ipairs(column) do
            local r, g, b = unpack(TILE_DEFS[tile.name].mapColor)
            mapData:setPixel(col - 1, row - 1, r, g, b, 1) -- set each pixel to the tile's rgb value
        end
    end
    return love.graphics.newImage(mapData)
end

MAP_PADDING = 10
TEXT_OFFSET = 2
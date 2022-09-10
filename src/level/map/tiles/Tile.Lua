--[[
    Tile class: The tiles that make the base for the Map
    attributes: id, mapX, mapY, sprite, biome, color(temp)
    @author Saverton
]]

Tile = Class{}

function Tile:init(name)
    self.name = name
end

function Tile:update(dt) end

function Tile:render(camx, camy, xPos, yPos)
    local x = ((xPos - 1) * TILE_SIZE) - camx
    local y = ((yPos - 1) * TILE_SIZE) - camy
    love.graphics.draw(gTextures[TILE_DEFS[self.name].texture], gFrames[TILE_DEFS[self.name].texture][TILE_DEFS[self.name].frame], x, y)
end
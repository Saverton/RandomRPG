--[[
    Tile class: The tiles that make the base for the Map
    attributes: id, mapX, mapY, sprite, biome, color(temp)
    @author Saverton
]]

Tile = Class{}

function Tile:init(name, x, y)
    self.name = name
    self.mapX = x
    self.mapY = y
    self.barrier = TILE_DEFS[self.name].barrier
end

function Tile:update(dt) end

function Tile:render(camx, camy)
    local x = ((self.mapX - 1) * TILE_SIZE) - camx
    local y = ((self.mapY - 1) * TILE_SIZE) - camy
    love.graphics.draw(gTextures[TILE_DEFS[self.name].texture], gFrames[TILE_DEFS[self.name].texture][TILE_DEFS[self.name].frame], x, y)
end
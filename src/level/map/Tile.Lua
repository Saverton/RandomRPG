--[[
    Tile class: The tiles that make the base for the Map
    attributes: id, mapX, mapY, sprite, biome, color(temp)
    @author Saverton
]]

Tile = Class{}

function Tile:init(def, x, y)
    self.id = def.id
    self.mapX = x
    self.mapY = y
    self.texture = def.texture
    self.frame = def.frame
end

function Tile:update(dt) end

function Tile:render(camx, camy)
    local x = ((self.mapX - 1) * TILE_SIZE) - camx
    local y = ((self.mapY - 1) * TILE_SIZE) - camy
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], x, y)
end
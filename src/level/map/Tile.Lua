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

    -- temporary color until sprites added
    self.color = def.color
end

function Tile:update(dt) end

function Tile:render(camx, camy)
    -- temporary color until sprites added
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', ((self.mapX - 1) * TILE_SIZE) - camx, ((self.mapY - 1) * TILE_SIZE) -camy, TILE_SIZE, TILE_SIZE)
    love.graphics.setColor({1, 1, 1, 1})

    --love.graphics.draw(gTextures[self.texture], gFrames[self.frame], self.x, self.y)
end
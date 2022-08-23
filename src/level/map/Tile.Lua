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
    self.sprite = def.sprite

    -- temporary color until sprites added
    self.color = def.color
end

function Tile:update(dt) end

function Tile:render(camx, camy)
    -- temporary color until sprites added
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', (self.mapX * TILE_SIZE) - camx, (self.mapY * TILE_SIZE) -camy, TILE_SIZE, TILE_SIZE)
    love.graphics.setColor({1, 1, 1, 1})

    --love.graphics.draw(self.sprite, self.x, self.y)
end
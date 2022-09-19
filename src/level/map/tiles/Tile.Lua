--[[
    Tile class: The tiles that make the base for the Maps.
    @author Saverton
]]

Tile = Class{}

function Tile:init(name, rotation)
    self.name = name
    self.rotation = rotation or 0
end

-- render the tile
function Tile:render(camx, camy, xPos, yPos)
    local x, y = ((xPos - 1) * TILE_SIZE) - camx + (ROTATION_OFFSETS[self.rotation].x * TILE_SIZE), 
        ((yPos - 1) * TILE_SIZE) - camy + (ROTATION_OFFSETS[self.rotation].y * TILE_SIZE) -- on screen position of the tile
    love.graphics.draw(gTextures[TILE_DEFS[self.name].texture], gFrames[TILE_DEFS[self.name].texture][TILE_DEFS[self.name].frame], 
        x, y, math.rad(self.rotation))
end
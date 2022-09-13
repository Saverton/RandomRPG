--[[
    Tile class: The tiles that make the base for the Maps.
    @author Saverton
]]

Tile = Class{}

function Tile:init(name)
    self.name = name
end

-- render the tile
function Tile:render(camx, camy, xPos, yPos)
    local x, y = ((xPos - 1) * TILE_SIZE) - camx, ((yPos - 1) * TILE_SIZE) - camy -- on screen position of the tile
    love.graphics.draw(gTextures[TILE_DEFS[self.name].texture], gFrames[TILE_DEFS[self.name].texture][TILE_DEFS[self.name].frame], x, y)
end
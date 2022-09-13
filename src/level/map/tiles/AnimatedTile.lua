--[[
    Seperate class to save memory when animating tiles.
    @author Saverton
]]

AnimatedTile = Class{__includes = Tile}

function AnimatedTile:init(def, animator)
    Tile.init(self, def)
    self.animator = animator or nil -- animator for the tile, shared with all other same type tiles
end

-- render the tile
function AnimatedTile:render(camx, camy, posX, posY)
    local x, y = ((posX - 1) * TILE_SIZE) - camx, ((posY - 1) * TILE_SIZE) - camy -- the on screen position of the tile
    self.animator:render(x, y)
end
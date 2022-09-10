--[[
    Seperate class to save memory when animating tiles.
    @author Saverton
]]

AnimatedTile = Class{__includes = Tile}

function AnimatedTile:init(def, animator)
    Tile.init(self, def)
    self.animator = animator or nil
end

function AnimatedTile:render(camx, camy, posX, posY)
    local x = ((posX - 1) * TILE_SIZE) - camx
    local y = ((posY - 1) * TILE_SIZE) - camy
    self.animator:render(x, y)
end
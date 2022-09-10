--[[
    Seperate class to save memory when animating tiles.
    @author Saverton
]]

AnimatedTile = Class{__includes = Tile}

function AnimatedTile:init(def, x, y, animator)
    Tile.init(self, def, x, y)
    self.animator = animator or nil
end

function AnimatedTile:render(camx, camy)
    local x = ((self.mapX - 1) * TILE_SIZE) - camx
    local y = ((self.mapY - 1) * TILE_SIZE) - camy
    self.animator:render(x, y)
end
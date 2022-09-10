--[[
    Animated feature class to save memory on animated features
    @author Saverton
]]

AnimatedFeature = Class{__includes = Feature}

function AnimatedFeature:init(name, animation)
    Feature.init(self, name) 
    self.animation = animation
end

function AnimatedFeature:update(dt)
    self.animation:update(dt)
end

function AnimatedFeature:render(camx, camy, posX, posY)
    local x = ((posX - 1) * TILE_SIZE) - camx
    local y = ((posY - 1) * TILE_SIZE) - camy
    self.animation:render(x, y)
end
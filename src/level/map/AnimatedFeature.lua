--[[
    Animated feature class to save memory on animated features
    @author Saverton
]]

AnimatedFeature = Class{__includes = Feature}

function AnimatedFeature:init(name, x, y, animation)
    Feature.init(self, name, x, y) 
    self.animation = animation
end

function AnimatedFeature:update(dt)
    self.animation:update(dt)
end

function AnimatedFeature:render(camx, camy)
    local x = ((self.mapX - 1) * TILE_SIZE) - camx
    local y = ((self.mapY - 1) * TILE_SIZE) - camy
    self.animation:render(x, y)
end
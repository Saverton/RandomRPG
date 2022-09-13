--[[
    Animated feature: inherits from features, class to save memory on animated features
    @author Saverton
]]

AnimatedFeature = Class{__includes = Feature}

function AnimatedFeature:init(name, animation)
    Feature.init(self, name) -- initiate the feature
    self.animation = animation -- this feature's animation
end

-- update the feature's animation
function AnimatedFeature:update(dt)
    self.animation:update(dt)
end

-- render the animated feature
function AnimatedFeature:render(camx, camy, posX, posY)
    local x, y = ((posX - 1) * TILE_SIZE) - camx, ((posY - 1) * TILE_SIZE) - camy -- position of the feature on screen
    self.animation:render(x, y) -- render animation
end
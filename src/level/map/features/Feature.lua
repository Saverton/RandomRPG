--[[
    Feature class: Features that will populate the world and make it more interesting.
    attributes: id, name, sprite, mapX, mapY, onInteract
    @author Saverton
]]

Feature = Class{}

function Feature:init(name, x, y)
    self.name = name or nil
    
    self.mapX = x
    self.mapY = y
end

function Feature:update(dt) end

function Feature:render(camx, camy)
    love.graphics.draw(gTextures[FEATURE_DEFS[self.name].texture], gFrames[FEATURE_DEFS[self.name].texture][FEATURE_DEFS[self.name].frame], 
        ((self.mapX - 1) * TILE_SIZE) - camx, ((self.mapY - 1) * TILE_SIZE) - camy)
end
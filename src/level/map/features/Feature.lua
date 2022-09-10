--[[
    Feature class: Features that will populate the world and make it more interesting.
    attributes: id, name, sprite, mapX, mapY, onInteract
    @author Saverton
]]

Feature = Class{}

function Feature:init(name)
    self.name = name or nil
end

function Feature:update(dt) end

function Feature:render(camx, camy, posX, posY)
    love.graphics.draw(gTextures[FEATURE_DEFS[self.name].texture], gFrames[FEATURE_DEFS[self.name].texture][FEATURE_DEFS[self.name].frame], 
        ((posX - 1) * TILE_SIZE) - camx, ((posY - 1) * TILE_SIZE) - camy)
end
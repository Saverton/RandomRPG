--[[
    Feature class: Features that will populate the world and make it more interesting.
    @author Saverton
]]

Feature = Class{}

function Feature:init(name)
    self.name = name or nil
end

-- render the feature
function Feature:render(camx, camy, posX, posY)
    love.graphics.draw(gTextures[FEATURE_DEFS[self.name].texture], gFrames[FEATURE_DEFS[self.name].texture][FEATURE_DEFS[self.name].frame], 
        ((posX - 1) * TILE_SIZE) - camx, ((posY - 1) * TILE_SIZE) - camy)
end
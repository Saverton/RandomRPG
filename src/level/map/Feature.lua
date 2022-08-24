--[[
    Feature class: Features that will populate the world and make it more interesting.
    attributes: id, name, sprite, mapX, mapY, onInteract
    @author Saverton
]]

Feature = Class{}

function Feature:init(def, x, y)
    self.id = def.id or 0
    self.name = def.name or nil
    self.texture = def.texture
    self.frame = def.frame
    
    self.mapX = x
    self.mapY = y

    self.onInteract = def.onInteract
    self.isSolid = def.isSolid or false
end

function Feature:update(dt) end

function Feature:render(camx, camy)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], 
        ((self.mapX - 1) * TILE_SIZE) - camx, ((self.mapY - 1) * TILE_SIZE) - camy)
end
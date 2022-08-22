--[[
    Feature class: Features that will populate the world and make it more interesting.
    attributes: id, name, sprite, mapX, mapY, onInteract
    @author Saverton
]]

Feature = Class{}

function Feature:init(def, x, y)
    self.id = def.id or 0
    self.name = def.name or nil
    self.sprite = def.sprite
    
    self.mapX = x
    self.mapY = y

    self.onInteract = def.onInteract
end

function Feature:update(dt) end

function Feature:render()
    love.graphics.draw(self.sprite, self.mapX * TILE_SIZE + MAP_OFFSET_X, self.mapY * TILE_SIZE + MAP_OFFSET_Y)
end
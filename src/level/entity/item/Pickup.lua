--[[
    Pickup class: the items that can be found on the ground and picked up by the player.
    attributes: x, y, name
    @author Saverton
]]

Pickup = Class{}

function Pickup:init(name, x, y, value)
    self.name = name
    self.x = x
    self.y = y
    self.value = value or 1
end

function Pickup:render(camera)
    love.graphics.draw(gTextures[ITEM_DEFS[self.name].texture], gFrames[ITEM_DEFS[self.name].texture][ITEM_DEFS[self.name].frame], 
        math.floor(self.x - camera.x), math.floor(self.y - camera.y))
end
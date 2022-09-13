--[[
    Pickup class: The items that can be found on the ground and picked up by the player. 
        Holds a name of the item, a quantity, and an x and y position.
    @author Saverton
]]

Pickup = Class{}

function Pickup:init(name, position, quantity)
    self.name = name -- name of the item
    self.x, self.y = position.x, position.y -- position on the map of the pickup
    self.quantity = quantity or 1 -- the quantity of the item in this pickup
end

function Pickup:render(camera)
    local onScreenX, onScreenY = math.floor(self.x - camera.x), math.floor(self.y - camera.y) -- on screen position of pickup
    local itemDefinition = ITEM_DEFS[self.name] -- reference to pickup item's definition table
    love.graphics.draw(gTextures[itemDefinition.texture], gFrames[itemDefinition.texture][itemDefinition.frame], onScreenX, onScreenY)
        -- draw a pickup at its on screen position
end
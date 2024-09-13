--[[
    The state in which the player receives a new special item. A jingle is played and the player is displayed standing still presenting the
    item to the camera.
    @author Saverton
]]

PlayerItemState = Class{__includes = EntityBaseState}

function PlayerItemState:init(entity)
    EntityBaseState.init(self, entity)
    self.entity:changeAnimation('item-get')
    self.item = nil
    self.entity.level.isUpdatingEntities = false
    self.exitTimer = {} -- timer to exit this player state
    Timer.after(3.2, function()
        self.entity:changeState('idle')
        self.entity.level.isUpdatingEntities = true
    end):group(self.exitTimer)
end

-- enter the state and set the item to the parameter item
function PlayerItemState:enter(params)
    self.item = params.item
    self.entity.level.music:pause() -- stop the level music
end

-- update the timer
function PlayerItemState:update(dt)
    Timer.update(dt, self.exitTimer)
end

-- draw the player holding the item.
function PlayerItemState:render(x, y)
    EntityBaseState.render(self, x, y) -- draw the player
    local itemX, itemY = x, y - 11
    self.item:render(itemX, itemY) -- draw the item above the player
end

-- exit the player state
function PlayerItemState:exit()
    self.entity.level.music:play() -- resume the music
end

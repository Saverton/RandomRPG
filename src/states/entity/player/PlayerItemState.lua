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
    gStateStack:push(PauseUpdatesState(3.2)) -- pause updates for 3.2 seconds
    self.exitTimer = {} -- timer to exit this player state
    Timer.after(0.01, function() self.entity:changeState('idle') end):group(self.exitTimer)
end

-- enter the state and set the item to the parameter item
function PlayerItemState:enter(params)
    self.item = params.item
    self.entity.level:pauseMusic() -- stop the level music
end

-- update the timer
function PlayerItemState:update(dt)
    print('pause updates state')
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
    self.entity.level:playMusic() -- resume the music
end
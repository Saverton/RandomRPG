--[[
    Interact State: when an entity is using an item
    @author Saverton
]]

EntityInteractState = Class{__includes = EntityBaseState}

function EntityInteractState:init(entity)
    EntityBaseState.init(self, entity) -- call entity base state
    self.waitTime = 0 -- time to wait before returning to idle state
    self.animate = false -- do not animate the entity in this state
    self.entity:changeAnimation('interact-' .. self.entity.direction) -- update animation
    self.cantUseItems = true -- entities cant use items in the interact state
end

-- enter the entity interact state, set the wait time before returning to normal and don't allow entity to use items
function EntityInteractState:enter(params)
    self.waitTime = params.time
    self.entity.canUseItem = false
end

-- update the entity interact state timer
function EntityInteractState:update(dt)
    self.waitTime = self.waitTime - dt -- update wait timer
    if self.waitTime <= 0 then
        self.entity:changeState('idle') -- when wait time is up, return to normal state
    end
end

-- return item use ability to entity
function EntityInteractState:exit()
    self.entity.canUseItem = true
end
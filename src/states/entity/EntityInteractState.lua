--[[
    Interact State: when the player is using an item
    @author Saverton
]]

EntityInteractState = Class{__includes = EntityBaseState}

function EntityInteractState:init(entity)
    EntityBaseState.init(self, entity)

    self.waitTime = 0

    self.animate = false

    self.entity:changeAnimation('interact-' .. self.entity.direction)
end

function EntityInteractState:enter(params)
    self.waitTime = params.time
    self.entity.canUseItem = false
end

function EntityInteractState:update(dt)
    self.waitTime = self.waitTime - dt

    if self.waitTime <= 0 then
        self.entity:changeState('idle')
    end
end

function EntityInteractState:exit()
    self.entity.canUseItem = true
end
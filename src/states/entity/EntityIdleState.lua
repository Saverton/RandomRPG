--[[
    Idle State: when an entity is standing still
    @author Saverton
]]

EntityIdleState = Class{__includes = EntityBaseState}

function EntityIdleState:init(entity)
    EntityBaseState.init(self, entity)
    self.animate = false -- do not animate the entity in this state
    self.entity:changeAnimation('idle-' .. self.entity.direction) -- update the animation to the new direction
end
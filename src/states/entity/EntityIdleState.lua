--[[
    Idle State: when an entity is standing still
    @author Saverton
]]

EntityIdleState = Class{__includes = EntityBaseState}

function EntityIdleState:init(entity)
    EntityBaseState.init(self, entity)

    self.animate = false

    self.entity:changeAnimation('idle-' .. self.entity.direction)
end
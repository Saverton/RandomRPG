--[[
    Idle State: when an entity is standing still
    @author Saverton
]]

EntityIdleState = Class{__includes = EntityBaseState}

function EntityIdleState:init(entity)
    EntityBaseState.init(self, entity)

    self.animate = false

    self.entity:changeAnimation('idle-' .. entity.direction)
end

function EntityIdleState:render(x, y)
    print('call EntityIdleState render entity at: ' .. tostring(x) .. ', ' .. tostring(y))
    EntityBaseState.render(self, x ,y)
end
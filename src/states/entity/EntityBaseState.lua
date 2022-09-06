--[[
    Base state for entity behavior.
    @author Saverton
]]

EntityBaseState = Class{__includes = BaseState}

function EntityBaseState:init(entity)
    self.entity = entity
end

function EntityBaseState:render(x, y)
    self.entity.animator:render(x, y)
end
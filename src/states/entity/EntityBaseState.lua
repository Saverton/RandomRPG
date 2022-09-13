--[[
    Base state for entity behavior, contains reference to owner entity and rendering function
    @author Saverton
]]

EntityBaseState = Class{__includes = BaseState}

function EntityBaseState:init(entity)
    self.entity = entity -- the owner entity
end

-- render the entity animation
function EntityBaseState:render(x, y)
    self.entity.animator:render(x, y)
end
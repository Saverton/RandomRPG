--[[
    State class that defines behavior for controlling the character moving in a Level.
    attributes: level
    @author Saverton
]]

WorldState = Class{__includes = BaseState}

function WorldState:init(defs)
    self.level = defs.level
end

function WorldState:update(dt) 
    self.level:update(dt)
end

function WorldState:render()
    self.level:render()
end
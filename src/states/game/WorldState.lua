--[[
    State class that defines behavior for controlling the character moving in a Level.
    attributes: level
    @author Saverton
]]

WorldState = Class{__includes = BaseState}

function WorldState:init(defs)
    self.level = defs.level or Level()
end

function WorldState:update(dt) 
    self.level:update(dt)

    if love.keyboard.wasPressed('r') then
        self.level = Level()
    end
end

function WorldState:render()
    self.level:render()
end
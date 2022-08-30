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

    -- reload level if pressed r
    if love.keyboard.wasPressed('r') then
        self.level = Level()
    end
    -- return to title if pressed escape
    if love.keyboard.wasPressed('escape') then
        gStateStack:pop()
    end
end

function WorldState:render()
    self.level:render()
end
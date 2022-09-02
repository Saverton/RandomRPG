--[[
    Menu State: the state in which the player looks at a menu.
    @author Saverton
]]

MenuState = Class{__includes = BaseState}

function MenuState:init(def, inst)
    self.menu = Menu(def, inst)
end

function MenuState:update(dt)
    self.menu:update(dt) 
    if love.keyboard.wasPressed('escape') then
        gStateStack:pop()
    end
end

function MenuState:render()
    self.menu:render()
end
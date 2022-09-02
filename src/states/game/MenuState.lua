--[[
    Menu State: the state in which the player looks at a menu.
    @author Saverton
]]

MenuState = Class{__includes = BaseState}

function MenuState:init(def)
    self.menu = Menu(def)
end

function MenuState:update(dt)
    self.menu:update(dt) 
end

function MenuState:render()
    self.menu:render()
end
--[[
    Menu State: the state in which the player looks at a menu.
    @author Saverton
]]

MenuState = Class{__includes = BaseState}

function MenuState:init(definitions, instance)
    self.menu = Menu(definitions, instance) -- menu displayed in this state
    self.shiftIn = definitions.shiftIn -- whether or not to shift the menu onto the screen
end

function MenuState:enter()
    if self.shiftIn then
        gStateStack:push(GuiShiftState(self.menu, 1)) -- push a shift in state for the menu from the top
    end
end

-- update the menu, check if closed with escape
function MenuState:update(dt)
    self.menu:update(dt) 
    if love.keyboard.wasPressed('escape') then
        gStateStack:pop() -- exit menu on 'escape'
    end
end

-- display the menu
function MenuState:render()
    self.menu:render()
end
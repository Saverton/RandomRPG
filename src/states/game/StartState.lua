--[[
    Class defining behavior for the title screen of RandomRPG
    @author Saverton
]]

StartState = Class{__includes = BaseState}

function StartState:init() 
    self.startMenu = Menu(MENU_DEFS['start']) -- menu to select start options from
end

-- update the start state
function StartState:update(dt)
    self.startMenu:update(dt) -- update start menu
    if love.keyboard.wasPressed('escape') then
        love.event.quit() -- leave app if escape is pressed
    end
end

-- render the startState
function StartState:render() 
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Random RPG Test', love.math.newTransform(0, 50), VIRTUAL_WIDTH, 'center') -- print title
    self.startMenu:render() -- render start menu
end
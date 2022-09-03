--[[
    Class defining behavior for the title screen of RandomRPG
    @author Saverton
]]

StartState = Class{__includes = BaseState}

function StartState:init() 
    self.startMenu = Menu(MENU_DEFS['start'])
end

function StartState:update(dt)
    self.startMenu:update(dt)

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render() 
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Random RPG Test', love.math.newTransform(0, 50), VIRTUAL_WIDTH, 'center')

    self.startMenu:render()
end

function StartState:exit() end
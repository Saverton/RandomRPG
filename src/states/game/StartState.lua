--[[
    Class defining behavior for the title screen of RandomRPG
    @author Saverton
]]

StartState = Class{__includes = BaseState}

function StartState:init() 

end

function StartState:update(dt) 
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:push(WorldState({}))
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render() 
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Random RPG Test', love.math.newTransform(0, (VIRTUAL_HEIGHT / 2) - 20), VIRTUAL_WIDTH, 'center')
end

function StartState:exit() end
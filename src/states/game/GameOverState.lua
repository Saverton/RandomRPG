--[[
    Class defining behavior for the Game Over screen of RandomRPG
    @author Saverton
]]

GameOverState = Class{__includes = BaseState}

function GameOverState:init() 

end

function GameOverState:update(dt) 
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:pop()
    end

end

function GameOverState:render() 
    love.graphics.setColor(0.5, 0, 0, 1)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Game Over', love.math.newTransform(0, (VIRTUAL_HEIGHT / 2) - 20), VIRTUAL_WIDTH, 'center')
end

function GameOverState:exit() end
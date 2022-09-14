--[[
    Class defining behavior for the Game Over screen of RandomRPG
    @author Saverton
]]

GameOverState = Class{__includes = BaseState}

-- check for input to return to title screen
function GameOverState:update(dt) 
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        love.audio.play(gSounds['gui']['menu_select_1']) -- play select sound
        gStateStack:pop() -- destroy game states back to title
        gStateStack:pop()
        gStateStack:pop()
    end
end

-- render game over screen
function GameOverState:render() 
    love.graphics.setColor(0.5, 0, 0, 1)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT) -- fill background rectangle
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    PrintFWithShadow('Game Over', 0, (VIRTUAL_HEIGHT / 2) - 20, VIRTUAL_WIDTH, 'center') -- print game over text
    love.graphics.setFont(gFonts['medium'])
    PrintFWithShadow('press \'enter\'', 0, (VIRTUAL_HEIGHT / 2) + 30, VIRTUAL_WIDTH, 'center') -- print directions text
end
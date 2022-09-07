--[[
    Create world state: the state in which the player creates a new world
    @author Saverton
]]

CreateWorldState = Class{__includes = BaseState}

function CreateWorldState:init()
    self.worldName = ''

    love.keyboard.setTextInput(true)
    inputtext = ''
end

function CreateWorldState:update(dt)
    if (love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')) and string.len(self.worldName) > 0 then
        gStateStack:pop()
        gStateStack:push(WorldState({debug = false, name = self.worldName}))
    elseif love.keyboard.wasPressed('escape') then
        gStateStack:pop()
    end

    self.worldName = inputtext
end

function love.textinput(t)
    inputtext = inputtext .. t
end

function CreateWorldState:render()
    love.graphics.setColor(0.5, 0.5, 0, 1)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Create World', 0, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, "center")
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('\'enter\' = create, \'esc\' = back', 0, VIRTUAL_HEIGHT / 2 - 10, VIRTUAL_WIDTH, "center")
    love.graphics.printf('World Name: ' .. self.worldName, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 + 10, 100, 'left')
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Create World', 1, VIRTUAL_HEIGHT / 2 - 49, VIRTUAL_WIDTH, "center")
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('\'enter\' = create, \'esc\' = back', 1, VIRTUAL_HEIGHT / 2 - 9, VIRTUAL_WIDTH, "center")
    love.graphics.printf('World Name: ' .. self.worldName, VIRTUAL_WIDTH / 2 - 49, VIRTUAL_HEIGHT / 2 + 11, 100, 'left')
end

function CreateWorldState:exit()
    love.keyboard.setTextInput(false)
end
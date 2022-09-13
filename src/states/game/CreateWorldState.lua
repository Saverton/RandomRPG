--[[
    Create world state: the state in which the player creates a new world
    @author Saverton
]]

CreateWorldState = Class{__includes = BaseState}

function CreateWorldState:init()
    self.worldName = '' -- name of the world, empty by default
    love.keyboard.setTextInput(true) -- accept keyboard input
    inputtext = '' -- blank input text
end

-- update the state by checking for text input or keyboard input
function CreateWorldState:update(dt)
    if (love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')) and string.len(self.worldName) > 0 then
        gStateStack:pop() -- create a new world if enter is pressed
        gStateStack:push(WorldState({debug = false, name = self.worldName}))
    elseif love.keyboard.wasPressed('escape') then
        gStateStack:pop() -- close this state if escape is pressed
    end
    self.worldName = inputtext -- set the worldname to the input text
end

--get input for this frame
function love.textinput(t)
    inputtext = inputtext .. t
end

-- render the create world screen
function CreateWorldState:render()
    love.graphics.setColor(0.5, 0.5, 0, 1)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT) -- draw background
    love.graphics.setFont(gFonts['large'])
    PrintFWithShadow('Create World', 0, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, "center") -- write title text
    love.graphics.setFont(gFonts['medium'])
    PrintFWithShadow('\'enter\' = create, \'esc\' = back', 0, VIRTUAL_HEIGHT / 2 - 10, VIRTUAL_WIDTH, "center") -- write direction text
    PrintFWithShadow('World Name: ' .. self.worldName, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 + 10, 100, 'left') -- write world name input text
end

-- stop accepting text input on closing the state
function CreateWorldState:exit()
    love.keyboard.setTextInput(false)
end
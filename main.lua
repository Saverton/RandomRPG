--[[
    Base main.lua for a Love2D project
    @author Saverton
]]

love.graphics.setDefaultFilter('nearest', 'nearest')
require 'src/Dependencies'

-- load the game
function love.load()
    love.window.setTitle('Random RPG')
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateStack = StateStack()
    gStateStack:push(StartState())
    -- helps start game faster for testing
    gStateStack:push(WorldState({debug = true}))

    love.keyboard.keysPressed = {}
    love.keyboard.setTextInput(false)
    mouseWheelMovement = {
        x = 0,
        y = 0
    }
    inputtext = ''
end

-- resize screen
function love.resize(w, h)
    push:resize(w, h)
end

-- add a key to the table of keys pressed this frame
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

-- return true if this key was pressed this frame
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

-- set mouse wheel movement according to movement this frame
function love.wheelmoved(x, y)
    mouseWheelMovement.x, mouseWheelMovement.y = x, y
end

-- return the y axis mouse wheel movement
function GetYScroll()
    return mouseWheelMovement.y
end

-- update the game
function love.update(dt)
    Timer.update(dt) -- update the timer
    gStateStack:update(dt) -- update the current state of the game

    love.keyboard.keysPressed = {} -- reset the keys pressed table
    mouseWheelMovement.x, mouseWheelMovement.y = 0, 0 -- reset mouse scroll
end

-- render the game this frame
function love.draw()
    push:start()
    gStateStack:render()
    push:finish()
end
--[[
    Base main.lua for a Love2D project
    @author Saverton
]]

love.graphics.setDefaultFilter('nearest', 'nearest')
require 'src/Dependencies'

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

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.wheelmoved(x, y)
    mouseWheelMovement.x = x
    mouseWheelMovement.y = y
end

function GetYScroll()
    return mouseWheelMovement.y
end

function love.update(dt)
    Timer.update(dt)
    gStateStack:update(dt)

    love.keyboard.keysPressed = {}
    mouseWheelMovement.x = 0
    mouseWheelMovement.y = 0
end

function love.draw()
    push:start()
    gStateStack:render()
    push:finish()
end
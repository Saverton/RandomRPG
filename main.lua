--[[
    Base main.lua for a Love2D project
    @author Saverton
]]

require 'src/Dependencies'

function love.load()
    love.window.setTitle('Random RPG')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateStack = StateStack()
    gStateStack:push(StartState())
    --gStateStack:push(WorldState({}))

    love.keyboard.keysPressed = {}
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

function love.update(dt)
    Timer.update(dt)
    gStateStack:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateStack:render()
    push:finish()
end
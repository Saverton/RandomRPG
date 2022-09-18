--[[
    Gui shift state: Gui panel shifts on screen from off screen.
    @author Saverton
]]

GuiShiftState = Class{__includes = BaseState}

function GuiShiftState:init(gui, direction)
    local endX, endY = gui.x, gui.y -- final position of the gui
    gui.x, gui.y = (VIRTUAL_WIDTH * DIRECTION_COORDS[direction].x) + gui.x, 
        (VIRTUAL_HEIGHT * DIRECTION_COORDS[direction].y) + gui.y -- gui start position
    Timer.tween(1, {
        [gui] = {x = endX, y = endY}
    }):finish(function() gStateStack:pop() end)
end
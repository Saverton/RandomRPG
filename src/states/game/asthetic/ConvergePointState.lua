--[[
    Converge Point: 4 rectangles of a certain color converge from the edge of the screen to a certain point, then executes a finish function
    @author Saverton
]]

ConvergePointState = Class{__includes = BaseState}

function ConvergePointState:init(point, color, time, onFinish)
    self.rects = {
        ['left'] = {x = 0, y = 0, width = 0, height = VIRTUAL_HEIGHT},
        ['top'] = {x = 0, y = 0, width = VIRTUAL_WIDTH, height = 0},
        ['right'] = {x = VIRTUAL_WIDTH, y = 0, width = VIRTUAL_WIDTH, height = VIRTUAL_HEIGHT},
        ['bottom'] = {x = 0, y = VIRTUAL_HEIGHT, width = VIRTUAL_WIDTH, height = VIRTUAL_HEIGHT}
    }
    self.color = color
    Timer.tween(time, {
        [self.rects['left']] = {width = point.x},
        [self.rects['top']] = {height = point.y},
        [self.rects['right']] = {x = point.x},
        [self.rects['bottom']] = {y = point.y}
    }):finish(function()
        gStateStack:pop()
        onFinish()
    end)
end

function ConvergePointState:render()
    love.graphics.setColor(self.color) 
    for i, rect in pairs(self.rects) do
        love.graphics.rectangle('fill', rect.x, rect.y, rect.width, rect.height)
    end
    love.graphics.setColor({1, 1, 1, 1})
end
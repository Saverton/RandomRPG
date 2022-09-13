--[[
    Converge Point: 4 rectangles of a certain color converge from the edge of the screen to a certain point, then executes a finish function
    @author Saverton
]]

ConvergePointState = Class{__includes = BaseState}

function ConvergePointState:init(point, color, time, onFinish)
    self.rectangles = {
        ['left'] = {x = 0, y = 0, width = 0, height = VIRTUAL_HEIGHT},
        ['top'] = {x = 0, y = 0, width = VIRTUAL_WIDTH, height = 0},
        ['right'] = {x = VIRTUAL_WIDTH, y = 0, width = VIRTUAL_WIDTH, height = VIRTUAL_HEIGHT},
        ['bottom'] = {x = 0, y = VIRTUAL_HEIGHT, width = VIRTUAL_WIDTH, height = VIRTUAL_HEIGHT}
    } -- rectangles that will converge
    self.color = color -- color of the rectangles
    Timer.tween(time, { -- tween rectangles to converge on the point
        [self.rectangles['left']] = {width = point.x},
        [self.rectangles['top']] = {height = point.y},
        [self.rectangles['right']] = {x = point.x},
        [self.rectangles['bottom']] = {y = point.y}
    }):finish(function() -- on finish, close this state and execute the onFinish function
        gStateStack:pop()
        onFinish()
    end)
end

-- render the converging rectangles
function ConvergePointState:render()
    love.graphics.setColor(self.color) -- set to the color of the rectangles
    for i, rectancle in pairs(self.rectangles) do
        love.graphics.rectangle('fill', rectancle.x, rectancle.y, rectancle.width, rectancle.height) -- draw each rectangle
    end
    love.graphics.setColor({1, 1, 1, 1}) -- reset color to default white
end
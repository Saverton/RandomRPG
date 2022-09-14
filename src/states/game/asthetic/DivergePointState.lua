--[[
    Diverge Point: 4 rectangles of a certain color diverge from a point to the edge of the screen
    @author Saverton
]]

DivergePointState = Class{__includes = BaseState}

function DivergePointState:init(point, color, time)
    self.rectangles = { -- rectangles to diverge from the point
        ['left'] = {x = 0, y = 0, width = point.x, height = VIRTUAL_HEIGHT},
        ['top'] = {x = 0, y = 0, width = VIRTUAL_WIDTH, height = point.y},
        ['right'] = {x = point.x, y = 0, width = VIRTUAL_WIDTH, height = VIRTUAL_HEIGHT},
        ['bottom'] = {x = 0, y = point.y, width = VIRTUAL_WIDTH, height = VIRTUAL_HEIGHT},
    }
    self.color = color -- color of the rectangles
    Timer.tween(time, { -- tween the rectangles off of the screen
        [self.rectangles['left']] = {width = 0},
        [self.rectangles['top']] = {height = 0},
        [self.rectangles['right']] = {x = VIRTUAL_WIDTH},
        [self.rectangles['bottom']] = {y = VIRTUAL_HEIGHT}
    }):finish(function() -- after finished, pop this game state
        gStateStack:pop()
    end)
end

-- render the diverge rectangles
function DivergePointState:render()
    love.graphics.setColor(self.color) -- set rectangle color
    for i, rectangle in pairs(self.rectangles) do
        love.graphics.rectangle('fill', rectangle.x, rectangle.y, rectangle.width, rectangle.height) -- draw rectangle
    end
    love.graphics.setColor({1, 1, 1, 1}) -- reset color to default white
end
--[[
    Camera shift state, the state in which the camera of a level is shifted to a new position.
    @author Saverton
]]

CameraShiftState = Class{__includes = BaseState}

function CameraShiftState:init(camera, newPos, time)
    Timer.tween(time, {
        [camera] = {x = newPos.x, y = newPos.y}
    }):finish(function() gStateStack:pop() end)
end

function CameraShiftState:update(dt)
    Timer.update(dt)
end
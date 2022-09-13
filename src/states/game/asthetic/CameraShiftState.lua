--[[
    Camera shift state: Used to display a smooth transition of the camera's position when transferring between rooms in a dungeon map.
    @author Saverton
]]

CameraShiftState = Class{__includes = BaseState}

function CameraShiftState:init(camera, newPosition, time)
    Timer.tween(time, {
        [camera] = {x = newPosition.x, y = newPosition.y} -- tween the camera's position to the new location
    }):finish(function() 
        gStateStack:pop() -- remove this game state from the stack
        camera:resetCambox() -- reset the camera's update box such that it only covers the on screen material.
    end)
end
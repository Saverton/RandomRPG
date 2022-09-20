--[[ 
    Generic game state that pushes an empty state on the stack to stop updates for a duration in the below states while still rendering.
    @author Saverton
]]

PauseUpdatesState = Class{__includes = BaseState}

function PauseUpdatesState:init(duration, onClose)
    self.pauseTimer = {}
    self.removeAfter = Timer.after(duration, function()
        gStateStack:pop() -- remove this state after the duration is up
    end):group(self.pauseTimer)
end

-- update the pause timer
function PauseUpdatesState:update(dt)
    Timer.update(dt, self.pauseTimer)
end
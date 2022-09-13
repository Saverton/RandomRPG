--[[
    NPC Idle State: for processing wandering AI when idle.
    @author Saverton
]]

NPCIdleState = Class{__includes = EntityIdleState}

function NPCIdleState:init(entity)
    EntityIdleState.init(self, entity)
    self.waitTime = 0 -- time before processing ai
end

-- enter the idle state with a time to wait
function NPCIdleState:enter(params)
    if params == nil then -- ensure params exists
        params = {}
    end
    self.waitTime = params.time or 1
end

-- update the idle timer
function NPCIdleState:update(dt)
    EntityIdleState.update(self, dt)
    self.waitTime = math.max(0, self.waitTime - dt) -- update wait waitTime
    if self.waitTime == 0 then -- if waitTime is 0, process ai
        self:processAI()
    end
end

-- process what to do next
function NPCIdleState:processAI()
    self.entity.direction = DIRECTIONS[math.random(1, 4)] -- choose a random direction
    self.entity:changeState('walk', {distance = math.random(1, 3)}) -- start wandering
end
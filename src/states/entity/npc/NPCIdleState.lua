--[[
    NPC Idle State: for processing wandering AI when idle.
    @author Saverton
]]

NPCIdleState = Class{__includes = EntityIdleState}

function NPCIdleState:init(entity)
    EntityIdleState.init(self, entity)

    self.timer = 0 -- time before change state
end

function NPCIdleState:enter(params)
    if params == nil then
        params = {}
    end
    self.timer = params.time or 1
end

function NPCIdleState:update(dt)
    EntityIdleState.update(self, dt) 

    self.timer = math.max(0, self.timer - dt) 
    if self.timer == 0 then
        self:processAI()
    end
end

function NPCIdleState:processAI()
    self.entity.direction = DIRECTIONS[math.random(1, 4)]

    self.entity:changeState('walk', {distance = math.random(1, 3)})
end
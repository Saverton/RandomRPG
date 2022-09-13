--[[
    Enemy Idle: when the enemy is standing still
    @author Saverton
]]

EnemyIdleState = Class{__includes = EntityIdleState}

function EnemyIdleState:init(entity)
    EntityIdleState.init(self, entity) -- initiate idle state
    self.waitTime = math.random(1, 10) -- time to wait before trying to move again
end

-- enter the enemy idle state, set new wait time
function EnemyIdleState:enter(params)
    if params == nil then -- ensure params exists
        params = {}
    end
    self.waitTime = params.time or math.random(1, 10)
end

-- update the entity's wait timer, and check if the wait timer is out
function EnemyIdleState:update(dt)
    EntityIdleState.update(self, dt)
    self.waitTime = math.max(0, self.waitTime - dt) -- update wait timer
    if self.waitTime == 0 or self.entity.target ~= nil then -- if timer is 0, process ai
        self:processAI()
    end
end

-- if the enemy has a target, then start seeking them, otherwise start wandering
function EnemyIdleState:processAI()
    if self.entity.target == nil then
        if self.waitTime == 0 then -- no target and time is up? wander a bit
            self.entity.direction = DIRECTIONS[math.random(1, 4)]
            self.entity:changeState('walk')
        end
    else -- start hunting target
        self.entity:changeState('walk', {tiles = 0})
    end
end
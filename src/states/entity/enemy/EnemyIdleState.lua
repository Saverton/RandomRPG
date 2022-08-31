--[[
    Enemy Idle: when the enemy is standing still
    attributes: waitTime (time until starts walking in seconds), timeWaited
    @author Saverton
]]

EnemyIdleState = Class{__includes = EntityIdleState}

function EnemyIdleState:init(entity)
    EntityIdleState.init(self, entity)

    self.waitTime = math.random(1, 10)

    self.timeWaited = 0
end

function EnemyIdleState:update(dt)
    EntityIdleState.update(self, dt)

    self.timeWaited = self.timeWaited + dt
end

function EnemyIdleState:processAI()
    if self.entity.target == nil then
        if self.timeWaited >= self.waitTime then
            self.entity.direction = DIRECTIONS[math.random(1, 4)]
            self.entity:changeState('walk')
        end
    else
        self.entity:changeState('walk', 0)
    end
    
end
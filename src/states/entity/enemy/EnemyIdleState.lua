--[[
    Enemy Idle: when the enemy is standing still
    attributes: waitTime (time until starts walking in seconds), timeWaited
    @author Saverton
]]

EnemyIdleState = Class{__includes = EntityIdleState}

function EnemyIdleState:init(entity)
    EntityIdleState.init(self, entity)

    self.waitTime = math.random(1, 10)
end

function EnemyIdleState:enter(time)
    self.waitTime = time or math.random(1, 10)
end

function EnemyIdleState:update(dt)
    EntityIdleState.update(self, dt)

    self.waitTime = math.max(0, self.waitTime - dt)

    if self.waitTime == 0 or self.entity.target ~= nil then
        self:processAI()
    end
end

function EnemyIdleState:processAI()
    if self.entity.target == nil then
        if self.waitTime == 0 then
            self.entity.direction = DIRECTIONS[math.random(1, 4)]
            self.entity:changeState('walk')
        end
    else
        self.entity:changeState('walk', 0)
    end
    
end
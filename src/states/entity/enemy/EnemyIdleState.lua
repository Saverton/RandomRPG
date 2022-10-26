--[[
    Enemy Idle: when the enemy is standing still
    @author Saverton
]]

EnemyIdleState = Class{__includes = EntityIdleState}

function EnemyIdleState:init(entity)
    EntityIdleState.init(self, entity) -- initiate idle state
    self.timer = {
        table = {},
        duration = 0
    } -- table with definitions for the Idle state's timer 
end

-- enter the enemy idle state, set new wait time
function EnemyIdleState:enter(params)
    self.timer.table = {} -- reset the table to empty
    self.timer.duration = (params or {}).duration or math.random(10) -- set the duration of the timer to a specified value or randomize it
end

-- update the entity's wait timer, and check if the wait timer is out
function EnemyIdleState:update(dt)
    EntityIdleState.update(self, dt)
    Timer.update(dt, self.timer.table) -- update the timer group
    self:processAI() -- process any ai
end

-- if the enemy has a target, then start seeking them, otherwise start wandering
function EnemyIdleState:processAI()
    return AI_DEFS[ENTITY_DEFS[self.entity.name].aiType][self.entity.aiSubType]['idle'](self.entity, self.timer)
end
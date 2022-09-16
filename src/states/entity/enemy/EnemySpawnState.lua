--[[
    State in which enemies spawn in with a cloud of smoke, giving the player a second or so to prepare in case an enemy spawns nearby.
    @author Saverton
]]

EnemySpawnState = Class{__includes = EntityBaseState}

function EnemySpawnState:init(entity)
    EntityBaseState.init(self, entity) -- initiate the base state
    self.spawnTimer = {}
    Timer.after(SPAWN_TIME, function() entity:changeState('idle') end):group(self.spawnTimer) -- timer to set enemy to idle state
    self.animation = Animation('smoke', 'appear') -- animation of the spawn smoke
end

-- update the spawn timer
function EnemySpawnState:update(dt)
    Timer.update(dt, self.spawnTimer)
end

-- render a cloud of smoke
function EnemySpawnState:render(x, y)
    self.animation:render(x, y)
end

-- call on exit of spawn state, sets enemy as active
function EnemySpawnState:exit()
    self.entity.active = true -- set the enemy as active
end
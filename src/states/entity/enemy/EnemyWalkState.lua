--[[
    Enemy Walk: when the enemy is on the move
    attributes: distanceToTravel, distanceTraveled
    @author Saverton
]]

EnemyWalkState = Class{__includes = EntityWalkState}

function EnemyWalkState:init(entity)
    EntityWalkState.init(self, entity)

    self.distanceToTravel = math.random(1, 5) * TILE_SIZE

    self.distanceTraveled = 0
end

function EnemyWalkState:update(dt)
    EntityWalkState.update(self, dt) 

    self.distanceTraveled = self.distanceTraveled + (self.entity.speed * dt) 
end

function EnemyWalkState:processAI()
    if self.distanceTraveled >= self.distanceToTravel then
        self.entity:changeState('idle')
    end
end
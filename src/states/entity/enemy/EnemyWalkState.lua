--[[
    Enemy Walk: when the enemy is on the move
    attributes: distanceToTravel, distanceTraveled
    @author Saverton
]]

EnemyWalkState = Class{__includes = EntityWalkState}

function EnemyWalkState:init(entity)
    EntityWalkState.init(self, entity)

    self.distanceToTravel = math.random(1, 5)

    self.distanceTraveled = 0
end    

function EnemyWalkState:update(dt)
    EntityWalkState.update(self, dt) 

    self.distanceTraveled = self.distanceTraveled + (self.entity.speed * dt) 

    if self.distanceTraveled >= self.distanceToTravel then
        self:processAI()
    end
end

function EnemyWalkState:processAI()
    self.entity:changeState('idle')
end

function EnemyWalkState:render(x, y)
    EntityWalkState.render(self, x ,y)
end
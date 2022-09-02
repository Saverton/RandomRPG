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

    self.hitObstacle = false
end

function EnemyWalkState:enter(dist)
    self.distanceToTravel = (dist or math.random(1, 5)) * TILE_SIZE
    self.distanceTraveled = 0
end

function EnemyWalkState:update(dt)
    EntityWalkState.update(self, dt) 

    self.distanceTraveled = self.distanceTraveled + (self.entity.speed * dt) 
    
end

function EnemyWalkState:processAI()
    if self.hitObstacle then
        self.hitObstacle = false
        self.entity.direction = DIRECTIONS[(DIRECTION_TO_NUM[self.entity.direction] % 4) + 1]
        self.distanceToTravel = 0.5 * TILE_SIZE
        self.distanceTraveled = 0
        self.entity:changeAnimation('walk-' .. self.entity.direction)
    end
    if self.distanceTraveled >= self.distanceToTravel then
        if self.entity.target == nil then
            self.entity:changeState('idle')
        else
            -- seek out target
            local targetXDif = self.entity.x - self.entity.target.x
            local targetYDif = self.entity.y - self.entity.target.y
            if math.abs(targetXDif) > math.abs(targetYDif) then
                --move on x axis
                if targetXDif < 0 then
                    self.entity.direction = 'right'
                else
                    self.entity.direction = 'left'
                end
            else
                --move on y axis
                if targetYDif < 0 then
                    self.entity.direction = 'down'
                else
                    self.entity.direction = 'up'
                end
            end
            self.distanceToTravel = 1 * TILE_SIZE
            self.distanceTraveled = 0
            self.entity:changeAnimation('walk-' .. self.entity.direction)
        end
    end
        
end
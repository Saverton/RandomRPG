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

    self.hitObstacle = false
end

function EnemyWalkState:enter(params)
    if params == nil then
        params = {}
    end
    self.distanceToTravel = params.dist or math.random(1, 5)
    self.distanceTraveled = 0
end

function EnemyWalkState:update(dt)
    EntityWalkState.update(self, dt) 

    self.distanceTraveled = self.distanceTraveled + (self.entity:getSpeed() * dt) 
    
    if self.distanceTraveled > TILE_SIZE then
        self.distanceToTravel = math.max(0, self.distanceToTravel - 1)
        self.distanceTraveled = 0
        self:processAI()
    end
    if self.hitObstacle then
        self:processAI()
    end
end

function EnemyWalkState:processAI()
    if self.hitObstacle then
        self.hitObstacle = false
        local dir = {-1, 1}
        self.entity.direction = DIRECTIONS[(((DIRECTION_TO_NUM[self.entity.direction] - 1) + dir[math.random(2)]) % 4) + 1]
        self.distanceToTravel = 1
        self.distanceTraveled = 0
        self.entity:changeAnimation('walk-' .. self.entity.direction)
    elseif self.entity.target ~= nil and self.distanceTraveled >= self.distanceToTravel then
        if #self.entity.items > 0 and GetDistance(self.entity, self.entity.target) <= 32 then
            self.entity:useHeldItem()
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
            self.distanceToTravel = 1
            self.distanceTraveled = 0
            self.entity:changeAnimation('walk-' .. self.entity.direction)
        end
    else
        self.entity:changeState('idle')
    end      
end
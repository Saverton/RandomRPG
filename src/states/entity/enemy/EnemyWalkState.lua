--[[
    Enemy Walk: when the enemy is on the move
    @author Saverton
]]

EnemyWalkState = Class{__includes = EntityWalkState}

function EnemyWalkState:init(entity)
    EntityWalkState.init(self, entity)
    self.tilesToTravel = math.random(1, 5) -- amount of tiles to travel before processing AI
    self.pixelsTraveled = 0 -- distance across a single tile that has been travelled
    self.hitObstacle = false -- flag for if the enemy runs into something that stops them
end

-- enter the enemy walk state, set a distance to travel
function EnemyWalkState:enter(params)
    if params == nil then -- ensure params exists
        params = {}
    end
    self.tilesToTravel = params.tiles or math.random(1, 5) -- set a distance to travel
    self.pixelsTraveled = 0 -- entity has traveled 0 pixels
end

-- update the enemy's walk
function EnemyWalkState:update(dt)
    EntityWalkState.update(self, dt) -- update movement
    self.pixelsTraveled = self.pixelsTraveled + (self.entity:getSpeed() * dt) -- update the amount of pixels traveled
    if self.pixelsTraveled > TILE_SIZE then -- if the entity has traveled a tile, update its travel info and process AI
        self.tilesToTravel = math.max(0, self.tilesToTravel - 1) -- decrement tilesToTravel
        self.pixelsTraveled = 0 -- reset pixelsTraveled
        self:processAI()
    elseif self.hitObstacle then -- if the entity hits an obstacle, process AI
        self:processAI()
    end
end

-- processa AI of the enemy, choose to pursue a target, wander, or stop walking
function EnemyWalkState:processAI()
    if self.hitObstacle then -- try a different direction
        self.hitObstacle = false
        local potentialDirectionChanges = {-1, 1}
        self.entity.direction = DIRECTIONS[(((DIRECTION_TO_NUM[self.entity.direction] - 1) + potentialDirectionChanges[math.random(2)]) % 4) + 1]
            -- change direction randomly either clockwise or counter clockwise
        self.tilesToTravel = 1 -- travel one tile before trying again
        self.pixelsTraveled = 0 -- reset pixelsTraveled
        self.entity:changeAnimation('walk-' .. self.entity.direction) -- update walk animation
    elseif self.entity.target ~= nil and self.pixelsTraveled >= self.tilesToTravel then -- update pursuit of target
        if #self.entity.items > 0 and GetDistance(self.entity, self.entity.target) <= 32 then -- if close to target and has an item
            self.entity:useHeldItem() -- use the held item
        else
            local targetXDif, targetYDif = self.entity.x - self.entity.target.x, self.entity.y - self.entity.target.y -- update target relative position
            if math.abs(targetXDif) > math.abs(targetYDif) then -- choose to move on the axis that the entity is furthest from
                if targetXDif < 0 then -- move on x axis closer to target
                    self.entity.direction = 'right'
                else
                    self.entity.direction = 'left'
                end
            else
                if targetYDif < 0 then -- move on y axis closer to target
                    self.entity.direction = 'down'
                else
                    self.entity.direction = 'up'
                end
            end
            self.tilesToTravel = 1 -- set to check again after traveling one tile
            self.pixelsTraveled = 0 -- reset pixelsTraveled
            self.entity:changeAnimation('walk-' .. self.entity.direction) -- update animation
        end
    else
        self.entity:changeState('idle') -- otherwise, stop walking
    end      
end
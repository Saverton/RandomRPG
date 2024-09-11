--[[
    Walk State: when an entity is moving
    @author Saverton
]]

EntityWalkState = Class{__includes = EntityBaseState}

function EntityWalkState:init(entity)
    EntityBaseState.init(self, entity) -- init base state
    self.animate = true -- animate the entity in this state
    self.entity:changeAnimation('walk-' .. self.entity.direction) -- update the animation
    self.collidesWithObstacle = false
end

function EntityWalkState:update(dt)
    self.collidesWithObstacle = false -- set the collidesWithObstacle flag to false so we don't get a false flag
    local oldX, oldY = self.entity.x, self.entity.y

    local dx, dy
    if self.entity.dirX ~= 0 and self.entity.dirY ~= 0 then
        dx = math.cos(math.rad(45)) * self.entity.dirX * (self.entity:getSpeed() * dt)
        dy = math.sin(math.rad(45)) * self.entity.dirY * (self.entity:getSpeed() * dt)
    else
        dx = self.entity.dirX * (self.entity:getSpeed() * dt)
        dy = self.entity.dirY * (self.entity:getSpeed() * dt)
    end

    self.entity.x = self.entity.x + dx
    self.entity.y = self.entity.y + dy

    local stopMoving = false-- flag to show if at any point the entity has to stop moving and change into an idle state.
    if (self.entity:checkCollisionWithMap(dt)) then
        -- if the movement causes a collision, move the entity back to its old location at the start of this frame
        self.entity.x, self.entity.y = oldX, oldY
        stopMoving = true
    end
    stopMoving = stopMoving or self:checkEntityWithMapBoundaries() -- keep entity on map
    if stopMoving then
        self.collidesWithObstacle = true -- if the entity has hit an obstacle, used in processing AI
    end
end

-- ensure that entity is inside of map, return true if hit boundary
function EntityWalkState:checkEntityWithMapBoundaries()
    local stopMoving = false -- flag to show collision
    local width, height = self.entity.level.map.width, self.entity.level.map.height -- width and height of map
    if self.entity.x < 0 then -- check x axis position with boundaries
        self.entity.x = 0
        stopMoving = true
    elseif self.entity.x + self.entity.width > (width * TILE_SIZE) then
        self.entity.x = math.floor((width * TILE_SIZE) - self.entity.width)
        stopMoving = true
    end
    if self.entity.y < 0 then -- check y axis position with boundaries
        self.entity.y = 0
        stopMoving = true
    elseif self.entity.y + self.entity.height > (height * TILE_SIZE) then
        self.entity.y = math.floor((height * TILE_SIZE) - self.entity.height)
        stopMoving = true
    end
    return stopMoving -- if the entity collides, this is true
end

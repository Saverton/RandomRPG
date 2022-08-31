--[[
    Walk State: when an entity is moving
    @author Saverton
]]

EntityWalkState = Class{__includes = EntityBaseState}

function EntityWalkState:init(entity)
    EntityBaseState.init(self, entity)

    self.animate = true

    self.entity:changeAnimation('walk-' .. self.entity.direction)
end

function EntityWalkState:update(dt)
    local oldX, oldY = self.entity.x, self.entity.y
    if self.entity.direction == 'up' then
        self.entity.y = self.entity.y - (self.entity:getSpeed() * dt)
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + (self.entity:getSpeed() * dt)
    elseif self.entity.direction == 'down' then
        self.entity.y = self.entity.y + (self.entity:getSpeed() * dt)
    elseif self.entity.direction == 'left' then
        self.entity.x = self.entity.x - (self.entity:getSpeed() * dt)
    end

    -- flag to show if at any point the entity has to stop moving and change into an idle state.
    local stopMoving = false

    -- if the movement causes a collision, move the entity back to its old spot, that way they can move next frame without having to back up.
    if (self.entity:checkCollision()) then
        self.entity.x, self.entity.y = oldX, oldY
        stopMoving = true
    end

    -- keep entity on map
    local size = self.entity.level.map.size
    if self.entity.x < 0 then
        self.entity.x = 0
        stopMoving = true
    elseif self.entity.x + self.entity.width > (size * TILE_SIZE) then
        self.entity.x = math.floor((size * TILE_SIZE) - self.entity.width)
        stopMoving = true
    end

    if self.entity.y < 0 then
        self.entity.y = 0
        stopMoving = true
    elseif self.entity.y + self.entity.height > (size * TILE_SIZE) then
        self.entity.y = math.floor((size * TILE_SIZE) - self.entity.height)
        stopMoving = true
    end

    if stopMoving then
        if self.entity.target ~= nil then
            self.entity:loseTarget()
        end
        self.entity:changeState('idle', 1)
    end
end
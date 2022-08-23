--[[
    Walk State: when an entity is moving
    @author Saverton
]]

EntityWalkState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity

    self.animate = true

    self.entity:changeAnimation('walk-' .. entity.direction)
end

function EntityIdleState:update(dt)
    if self.entity.direction == 'up' then
        self.entity.y = self.entity.y - (self.entity.speed * dt)
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + (self.entity.speed * dt)
    elseif self.entity.direction == 'down' then
        self.entity.y = self.entity.y + (self.entity.speed * dt)
    elseif self.entity.direction == 'left' then
        self.entity.x = self.entity.x - (self.entity.speed * dt)
    end
end

function EntityIdleState:render(x, y)
    love.graphics.draw(self.entity.currentAnimation.texture, self.entity.currentAnimation.frames[self.entity.currentFrame],
        x, y, DEFAULT_ENTITY_ROTATION, self.entity.currentAnimation.xScale)
end
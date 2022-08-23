--[[
    Idle State: when an entity is standing still
    @author Saverton
]]

EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity

    self.animate = false

    self.entity:changeAnimation('idle-' .. entity.direction)
end

function EntityIdleState:update(dt) end

function EntityIdleState:render(x, y)
    love.graphics.draw(self.entity.currentAnimation.texture, self.entity.currentAnimation.frames[self.entity.currentFrame],
        x, y, DEFAULT_ENTITY_ROTATION, self.entity.currentAnimation.xScale)
end
--[[
    Walk State: when the player is walking
    @author Saverton
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerIdleState:init(entity)
    EntityIdleState.init(self, entity)
end

function PlayerIdleState:update(dt)
    EntityIdleState.update(self)

    if love.keyboard.isDown('w') then
        self.entity.direction = 'up'
    elseif love.keyboard.isDown('d') then
        self.entity.direction = 'right'
    elseif love.keyboard.isDown('s') then
        self.entity.direction = 'down'
    elseif love.keyboard.isDown('a') then
        self.entity.direction = 'left'
    else
        self.entity:changeState('idle')
    end
end

function PlayerIdleState:render(x, y)
    EntityIdleState.render(self, x ,y)
end
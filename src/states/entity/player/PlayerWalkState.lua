--[[
    Walk State: when the player is walking
    @author Saverton
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:update(dt)
    EntityWalkState.update(self, dt)
    local lastDirection = self.entity.direction
    local newDirection = lastDirection

    if love.keyboard.isDown('w') then
        newDirection = 'up'
    elseif love.keyboard.isDown('d') then
        newDirection = 'right'
    elseif love.keyboard.isDown('s') then
        newDirection = 'down'
    elseif love.keyboard.isDown('a') then
        newDirection = 'left'
    else
        self.entity:changeState('idle')
    end

    if lastDirection ~= newDirection then
        self.entity:changeAnimation('walk-' .. newDirection)
    end
end

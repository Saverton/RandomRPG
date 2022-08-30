--[[
    Walk State: when the player is walking
    @author Saverton
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:update(dt)
    EntityWalkState.update(self, dt)
    local lastDirection = self.entity.direction
    local newDirection = lastDirection

    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        newDirection = 'up'
    elseif love.keyboard.isDown('d') or love.keyboard.isDown('right')then
        newDirection = 'right'
    elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        newDirection = 'down'
    elseif love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        newDirection = 'left'
    else
        self.entity:changeState('idle')
    end

    if lastDirection ~= newDirection then
        self.entity.direction = newDirection
        self.entity:changeAnimation('walk-' .. newDirection)
    end
end

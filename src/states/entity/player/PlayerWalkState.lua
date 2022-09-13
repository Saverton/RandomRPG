--[[
    Walk State: tracks input when the player is walking
    @author Saverton
]]

PlayerWalkState = Class{__includes = EntityWalkState}

-- update the player's walk state
function PlayerWalkState:update(dt)
    EntityWalkState.update(self, dt) -- call entity walk state
    local lastDirection = self.entity.direction -- the current direction
    local newDirection = lastDirection -- the direction input this frame
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then -- check for input to keep walking/change direction and keep walking
        newDirection = 'up'
    elseif love.keyboard.isDown('d') or love.keyboard.isDown('right')then
        newDirection = 'right'
    elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        newDirection = 'down'
    elseif love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        newDirection = 'left'
    else -- if no input, return to idle state
        self.entity:changeState('idle')
    end
    if lastDirection ~= newDirection then -- if the direction changes, update the direction and animation
        self.entity.direction = newDirection
        self.entity:changeAnimation('walk-' .. newDirection)
    end
end

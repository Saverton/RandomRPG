--[[
    Idle State: tracks input when the player is standing still
    @author Saverton
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(entity)
    EntityIdleState.init(self, entity) -- call entity idle state
end

-- check for keyboard input to change player's direction and state
function PlayerIdleState:update()
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        self.entity:changeState('walk')
        self.entity:setDirection('up')
    elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        self.entity:changeState('walk')
        self.entity:setDirection('right')
    elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
        self.entity:setDirection('down')
    elseif love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        self.entity:changeState('walk')
        self.entity:setDirection('left')
    end
end

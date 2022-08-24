--[[
    Idle State: when the player is standing still
    @author Saverton
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(entity)
    EntityIdleState.init(self, entity)
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('w') then
        self.entity.direction = 'up'
        self.entity:changeState('walk')
    elseif love.keyboard.isDown('d') then
        self.entity.direction = 'right'
        self.entity:changeState('walk')
    elseif love.keyboard.isDown('s') then
        self.entity.direction = 'down'
        self.entity:changeState('walk')
    elseif love.keyboard.isDown('a') then
        self.entity.direction = 'left'
        self.entity:changeState('walk')
    end
end
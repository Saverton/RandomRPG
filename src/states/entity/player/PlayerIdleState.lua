--[[
    Idle State: when the player is standing still
    @author Saverton
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(entity)
    EntityIdleState.init(self, entity)
end

function PlayerIdleState:update(dt)
    EntityIdleState.update(self)

    if love.keyboard.wasPressed('w') then
        self.entity.direction = 'up'
        self.entity:changeState('walk')
    elseif love.keyboard.wasPressed('d') then
        self.entity.direction = 'right'
        self.entity:changeState('walk')
    elseif love.keyboard.wasPressed('s') then
        self.entity.direction = 'down'
        self.entity:changeState('walk')
    elseif love.keyboard.wasPressed('a') then
        self.entity.direction = 'left'
        self.entity:changeState('walk')
    end
end

function PlayerIdleState:render(x, y)
    EntityIdleState.render(self, x ,y)
end
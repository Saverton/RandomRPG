--[[
    Player Class: defines behavior of the player that the user controls.
    attributes: x, y, width, height, onDeath()
]]

Player = Class{__includes = Entity}

function Player:render(camera)
    Entity.render(self, camera, PLAYER_X_OFFSET, PLAYER_Y_OFFSET)
    -- debug: render player bounds
    -- love.graphics.rectangle('line', self.x - camera.x, self.y - camera.y, PLAYER_WIDTH, PLAYER_HEIGHT)
end

function Player:update(dt)
    Entity.update(self, dt)

    -- if space is pressed, launch a sword.
    if self.canAttack and love.keyboard.wasPressed('space') then
        love.audio.play(gSounds['sword_swing_1'])
        self:changeState('interact', {time = 0.3})
        -- calculate starting position and rotation of the sword
        local pos = {x = self.x, y = self.y, dx = 0, dy = 0}
        if self.direction == 'up' then
            pos.x = self.x - 3
            pos.y = self.y - 18
        elseif self.direction == 'right' then
            pos.x = self.x + 10
        elseif self.direction == 'down' then
            pos.x = self.x - 3
            pos.y = self.y + 10
        elseif self.direction == 'left' then
            pos.x = self.x - 16
        end

        table.insert(self.projectiles, Projectile('sword', {
            x = pos.x,
            y = pos.y
        }, pos.dx, pos.dy, DIRECTION_TO_NUM[self.direction]))
    end

    --check for death
    if self.currenthp <= 0 then
        self:onDeath()
        gStateStack:pop()
        gStateStack:push(GameOverState())
    end
end
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
    if love.keyboard.wasPressed('space') then
        self:changeState('interact', {time = 0.3})
        -- calculate starting position and rotation of the sword
        local pos = {x = self.x, y = self.y, dx = 0, dy = 0}
        if self.direction == 'up' then
            pos.y = self.y - 16
            pos.dy = -1
        elseif self.direction == 'right' then
            pos.x = self.x + 24
            pos.dx = 1
        elseif self.direction == 'down' then
            pos.x = self.x + 16
            pos.y = self.y + 20
            pos.dy = 1
        elseif self.direction == 'left' then
            pos.x = self.x - 16
            pos.y = self.y + 16
            pos.dx = -1
        end

        table.insert(self.projectiles, Projectile(PROJECTILE_DEFS['sword'], {
            x = pos.x,
            y = pos.y,
            rotation = math.rad((DIRECTION_TO_NUM[self.direction] - 1) * 90)
        }, pos.dx, pos.dy))
    end

    --check for death
    if self.currenthp <= 0 then
        gStateStack:pop()
        gStateStack:push(GameOverState())
    end
end
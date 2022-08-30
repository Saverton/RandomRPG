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

    --check for death
    if self.currenthp <= 0 then
        gStateStack:pop()
        gStateStack:push(GameOverState())
    end
end
--[[
    Walk State: tracks input when the player is walking
    @author Saverton
]]

PlayerWalkState = Class{__includes = EntityWalkState}

-- update the player's walk state
function PlayerWalkState:update(dt)
    EntityWalkState.update(self, dt) -- call entity walk state

    local currDir = self.entity.direction
    local newDir = currDir
    local dirX, dirY = 0, 0

    -- check for input to keep walking/change direction and keep walking
    if love.keyboard.isDown('d') or love.keyboard.isDown('right')then
        newDir = 'right'
        dirX = 1
    elseif love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        newDir = 'left'
        dirX = -1
    end

    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        newDir = 'up'
        dirY = -1
    elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        newDir = 'down'
        dirY = 1
    end


    if currDir ~= newDir then
        self.entity:setDirection(newDir)
    end

    self.entity:setDirXY(dirX, dirY)

    if dirX == 0 and dirY == 0 then
        self.entity:changeState('idle')
    end
end

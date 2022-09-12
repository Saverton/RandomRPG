--[[
    InvincibilityManager: Manages the invincibility of combat entities after being hit.
    @author Saverton
]]

InvincibilityManager = Class{}

function InvincibilityManager:init()
    self.invincible = false
    self.frameCounter = 0
    self.timer = 0
end

-- update the invincibility manager if invincible
function InvincibilityManager:update(dt)
    if self.invincible then
        self.timer = math.max(0, self.timer - dt) -- update timer
        self.frameCounter = self.frameCounter + 1 -- update frameCounter
        if self.timer == 0 then -- when timer is up, lose invincibility and stop counting frames
            self.invincible = false
            self.frameCounter = 0
        end
    end
end

-- set the entity invincible
function InvincibilityManager:goInvincible()
    self.invincible = true
    self.timer = INVINCIBLE_TIME -- set timer to global invincibility time
end

-- return the current color according to the frame Counter
function InvincibilityManager:getCurrentColor()
    local r, g, b, a = love.graphics.getColor() -- get the current drawing color
    if self.invincible and self.frameCounter % 4 == 0 then
        a = 0.5 -- if the entity is invincible and the frame counter is a multiple of 4, set opacity to half
    end
    return {r, g, b, a} -- return the modified color
end
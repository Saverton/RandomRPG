--[[
    Push Manager: manages all behavior for when an entity is pushed. updates position accordingly.
    @author Saverton
]]

PushManager = Class{}

function PushManager:init(entity)
    self.entity = entity -- reference to the owner entity
    self.isPushed = false -- is the entity currently pushed?
    self.pushdx, self.pushdy = 0, 0 -- the velocity of the push
end

-- update push behavior, if pushed
function PushManager:update(dt)
    if self.isPushed then -- check if the entity is pushed
        local x, y = self.entity.x + math.floor(self.pushdx), self.entity.y + math.floor(self.pushdy) -- set the new position after the push 
        if not self.entity:checkCollisionWithMap(x, y) then
            self.entity.x, self.entity.y = x, y -- if there is no collision, set the new position of the entity
        end
        self.pushdx, self.pushdy = self.pushdx / PUSH_DECAY, self.pushdy / PUSH_DECAY -- decay the push amount
        if math.abs(self.pushdx) < 1 and math.abs(self.pushdy) < 1 then 
            self.isPushed = false -- if the push amount is less than one for both x and y, end the push
        end
    end
end

-- push the entity with a strength and direction
function PushManager:push(pushStrength, pushDirection)
    self.isPushed = true -- set the entity push flag to true
    self.pushdx, self.pushdy = pushStrength * DIRECTION_COORDS[pushDirection].x, push.strength * DIRECTION_COORDS[pushDirection].y -- set the push velocities
end
--[[
    Projectile class; defines any damaging object separate from another entity.
    attributes: x, y, rotation, texture, frame, width, height, damage, dx, dy, lifetime, hits
    @author Saverton
]]

Projectile = Class{}

function Projectile:init(def, pos, dx, dy)
    self.x = pos.x
    self.y = pos.y
    self.rotation = pos.rotation
    self.width = def.width
    self.height = def.height

    self.texture = def.texture
    self.frame = def.frame
    self.damage = def.damage
    self.dx = dx * def.speed
    self.dy = dy * def.speed
    self.lifetime = def.lifetime
    -- number of hits before projectile dies
    self.hits = def.hits
end

function Projectile:update(dt)
    -- update position
    self.x = self.x + (self.dx * dt)
    self.y = self.y + (self.dy * dt) 

    --update lifetime
    self.lifetime = self.lifetime - dt
end

-- target must be an entity
function Projectile:hit(target)
    target:damage(self.damage)
    self.hits = self.hits - 1
end

function Projectile:render(camera)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], math.floor(self.x - camera.x), math.floor(self.y - camera.y), self.rotation)
end
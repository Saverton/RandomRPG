--[[
    Projectile class; defines any damaging object separate from another entity.
    attributes: x, y, rotation, texture, frame, width, height, damage, dx, dy, lifetime, hits
    @author Saverton
]]

Projectile = Class{}

function Projectile:init(name, pos, dx, dy, frame)
    self.name = name

    self.x = pos.x
    self.y = pos.y
    self.width = PROJECTILE_DEFS[self.name].width
    self.height = PROJECTILE_DEFS[self.name].height

    self.frame = frame
    
    self.dx = dx * PROJECTILE_DEFS[self.name].speed
    self.dy = dy * PROJECTILE_DEFS[self.name].speed
    self.lifetime = PROJECTILE_DEFS[self.name].lifetime
    -- number of hits before projectile dies
    self.hits = PROJECTILE_DEFS[self.name].hits
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
    target:damage(PROJECTILE_DEFS[self.name].damage)
    self.hits = self.hits - 1
end

function Projectile:render(camera)
    --debug: hitbox
    -- love.graphics.rectangle('line', math.floor(self.x - camera.x),  math.floor(self.y - camera.y), self.width, self.height)
    love.graphics.draw(gTextures[PROJECTILE_DEFS[self.name].texture], 
        gFrames[PROJECTILE_DEFS[self.name].texture][PROJECTILE_DEFS[self.name].frames[self.frame]],
        math.floor(self.x - camera.x), math.floor(self.y - camera.y))
end
--[[
    Projectile class; defines any damaging object separate from another entity.
    attributes: x, y, rotation, texture, frame, width, height, damage, dx, dy, lifetime, hits
    @author Saverton
]]

Projectile = Class{}

function Projectile:init(name, origin)
    self.name = name

    self.origin = origin
    self:getPosition()

    self.width = PROJECTILE_DEFS[self.name].width
    self.height = PROJECTILE_DEFS[self.name].height

    self.animation = Animation('projectiles', self.name)
    
    self.lifetime = PROJECTILE_DEFS[self.name].lifetime

    self.damage = PROJECTILE_DEFS[self.name].damage
    -- number of hits before projectile dies
    self.hits = PROJECTILE_DEFS[self.name].hits
end

function Projectile:update(dt)
    -- update animation
    self.animation:update(dt) 

    -- update position
    self.x = self.x + (self.dx * dt)
    self.y = self.y + (self.dy * dt) 

    --update lifetime
    self.lifetime = self.lifetime - dt
end

function Projectile:updateOrigin(x, y)
    self.origin.x = x
    self.origin.y = y

    self:getPosition()
end

-- target must be an entity
function Projectile:hit(target, attacker)
    local damage = PROJECTILE_DEFS[self.name].damage
    damage = damage * (attacker:getDamage() / math.max(attacker.attack, 1))
    local inflictions = PROJECTILE_DEFS[self.name].inflictions
    for i, inflict in pairs(attacker.inflictions) do
        if not ContainsName(inflictions, inflict.name) then
            table.insert(inflictions, inflict)
        end
    end
    
    target:damage(damage, PROJECTILE_DEFS[self.name].push, self, inflictions)
    self.hits = self.hits - 1
end

function Projectile:render(camera)
    --debug: hitbox
    -- love.graphics.rectangle('line', math.floor(self.x - camera.x),  math.floor(self.y - camera.y), self.width, self.height)
    self.animation:render(self.x + self.ox - camera.x, self.y + self.oy - camera.y, self.rotation)
end

--gets the starting position of a projectile
function Projectile:getPosition()
    -- calculate starting position and rotation of the sword
    self.x = self.origin.x
    self.y = self.origin.y
    self.rotation = 0
    self.ox = 0
    self.oy = 0
    self.dx = 0
    self.dy = 0
    if self.origin.direction == 'up' then
        self.x = self.origin.x - 3
        self.y = self.origin.y - 18
        self.dy = -1
    elseif self.origin.direction == 'right' then
        self.x = self.origin.x + 10
        self.ox = 16
        self.dx = 1
    elseif self.origin.direction == 'down' then
        self.x = self.origin.x - 3
        self.y = self.origin.y + 10
        self.ox = 16
        self.oy = 16
        self.dy = 1
    elseif self.origin.direction == 'left' then
        self.x = self.origin.x - 16
        self.oy = 16
        self.dx = -1
    end
    self.rotation = math.rad((DIRECTION_TO_NUM[self.origin.direction] - 1) * 90)

    self.dx = self.dx * PROJECTILE_DEFS[self.name].speed
    self.dy = self.dy * PROJECTILE_DEFS[self.name].speed
end

function Projectile:checkCollision(map)
    local tilesToCheck = {}
    -- add one to each to match feature map indexes
    local mapX, mapY, mapXB, mapYB = math.floor((self.x + PLAYER_HITBOX_X_OFFSET) / TILE_SIZE) + 1, math.floor((self.y + PLAYER_HITBOX_Y_OFFSET) / TILE_SIZE) + 1, 
        math.floor((self.x + self.width + PLAYER_HITBOX_XB_OFFSET) / TILE_SIZE) + 1, math.floor((self.y + self.height + PLAYER_HITBOX_YB_OFFSET) / TILE_SIZE) + 1
    local collide = false

    if self.dy < 0 then
        table.insert(tilesToCheck, {mapX, mapY})
        table.insert(tilesToCheck, {mapXB, mapY})
    end
    if self.dx > 0 then
        table.insert(tilesToCheck, {mapXB, mapY})
        table.insert(tilesToCheck, {mapXB, mapYB})
    end
    if self.dy > 0 then
        table.insert(tilesToCheck, {mapX, mapYB})
        table.insert(tilesToCheck, {mapXB, mapYB})
    end
    if self.dx < 0 then
        table.insert(tilesToCheck, {mapX, mapY})
        table.insert(tilesToCheck, {mapX, mapYB})
    end

    for i, coord in pairs(tilesToCheck) do
        if coord[1] < 1 or coord[1] > map.size or coord[2] < 1 or coord[2] > map.size then
            goto continue
        end
        local feature = map.featureMap[coord[1]][coord[2]]
        if (feature ~= nil and FEATURE_DEFS[feature.name].isSolid) then
            collide = true
            break
        end
        ::continue::
    end

    return collide
end
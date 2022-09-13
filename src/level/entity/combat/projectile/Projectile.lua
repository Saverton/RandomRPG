--[[
    Projectile class: defines any damaging object separate from an entity, belongs to an entity.
    @author Saverton
]]

Projectile = Class{}

function Projectile:init(name, origin)
    self.name = name -- name of the projectile
    self.origin = origin -- originating position, direction, and velocity directions of the projectile
    self:getPosition() -- get the position of the projectile based on the origin
    self.animation = Animation('projectiles', self.name) -- animator for the projectile
    self.lifetime = PROJECTILE_DEFS[self.name].lifetime -- lifetime of the projectile before despawn (in seconds)
    self.hits = PROJECTILE_DEFS[self.name].hits -- number of hits before projectile itself despawns
end

-- update the projectile
function Projectile:update(dt)
    self.animation:update(dt) -- update animation
    self.x, self.y = self.x + (self.dx * dt), self.y + (self.dy * dt) -- update position
    self.lifetime = self.lifetime - dt -- update projectile lifetime
end

-- render the projectile
function Projectile:render(camera)
    self.animation:render(self.x + self.ox - camera.x, self.y + self.oy - camera.y, self.rotation)
end

-- update attached projectiles to their new origin
function Projectile:updateOrigin(x, y)
    self.origin.x, self.origin.y = x, y -- get new origin position
    self:getPosition() -- update projectile position according to origin
end

-- projectile hits a target, inflicts damage on the target and takes a hit on the projectile
function Projectile:hit(target, attacker)
    local damage = self:getDamage(attacker)
    local inflictions = self:getInflictions(attacker)
    target:damage(damage, {strength = PROJECTILE_DEFS[self.name].push, direction = self.origin.direction}, inflictions) -- damage target
    self.hits = self.hits - 1 -- update projectile hits
end

-- get the projectile's damage
function Projectile:getDamage(attacker)
    local damage = PROJECTILE_DEFS[self.name].damage -- get the projectile's damage
    if PROJECTILE_DEFS[self.name].type ~= 'none' then
        damage = damage + attacker:getAttack() -- add attacker's damage
    end
end

-- get the projectile's inflictions
function Projectile:getInflictions(attacker)
    local inflictions = PROJECTILE_DEFS[self.name].inflictions -- get the projectile's inflictions
    for i, inflict in pairs(attacker.inflictions) do
        if not ContainsName(inflictions, inflict.name) then
            table.insert(inflictions, inflict) -- add any of the attacker's inflictions
        end
    end
    return inflictions
end

--gets the position of a projectile according to its origin
function Projectile:getPosition()
    self.x, self.y = self.origin.x, self.origin.y -- set origin position x and y
    self.rotation = 0
    self.offsetX, self.offsetY = 0, 0 -- set offsets to default 0
    self.dx, self.dy = DIRECTION_COORDS[DIRECTION_TO_NUM[self.origin.direction]].x * PROJECTILE_DEFS[self.name].speed, 
        DIRECTION_COORDS[DIRECTION_TO_NUM[self.origin.direction]].y * PROJECTILE_DEFS[self.name].speed
        -- set directional velocities according to origin direction and projectile speed
    if self.origin.direction == 'up' then
        self.x, self.y = self.origin.x - 3, self.origin.y - 18
    elseif self.origin.direction == 'right' then
        self.x, self.offsetX = self.origin.x + 10, 16
    elseif self.origin.direction == 'down' then
        self.x, self.y, self.offsetX, self.offsetY = self.origin.x - 3, self.origin.y + 10, 16, 16
    elseif self.origin.direction == 'left' then
        self.x, self.offsetY = self.origin.x - 16, 16
    end -- set offsets and position according to origin direction
    self.rotation = math.rad((DIRECTION_TO_NUM[self.origin.direction] - 1) * 90) -- set rotation according to direction
end

-- check the collision of the projectile with the map.
function Projectile:checkCollisionWithMap(map)
    local tilesToCheck = self:getCollisionCheckList() -- get a list of tiles to check for collision
    for i, coordinate in pairs(tilesToCheck) do
        if coordinate.x < 1 or coordinate.y > map.size or coordinate.y < 1 or coordinate.y > map.size then
            goto skipThisCoordinate -- if the coordinate is out of map bounds, skip the check
        end
        local feature = map.featureMap[coordinate.x][coordinate.y]
        if (feature ~= nil and FEATURE_DEFS[feature.name].isSolid) then
            return true -- collision found
        end
        ::skipThisCoordinate:: -- skip checking label
    end
    return false
end

-- return a list of coordinates to check for a collision
function Projectile:getCollisionCheckList()
    local leftCol, rightCol, topRow, bottomRow = (math.ceil(self.x / TILE_SIZE)), (math.ceil((self.x + self.width) / TILE_SIZE)), 
        (math.ceil(self.y / TILE_SIZE)), (math.ceil((self.y + self.height) / TILE_SIZE)) -- get the map coordinates of each side of this projectile
    local dx, dy = self.dy, self.dy -- get projectile's directional velocity
    local checkList = {} -- the list of coordinates to be checked for collision
    if dx < 0 or dy < 0 then
        table.insert(checkList, {x = leftCol, y = topRow})
    end if dx > 0 or dy < 0 then
        table.insert(checkList, {x = rightCol, y = topRow})
    end if dx > 0 or dy > 0 then
        table.insert(checkList, {x = rightCol, y = bottomRow})
    end if dx < 0 or dy > 0 then
        table.insert(checkList, {x = leftCol, y = bottomRow})
    end -- add in coordinates according to the projectile's x and y velocity
    return checkList
end
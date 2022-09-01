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

    self.damage = PROJECTILE_DEFS[self.name].damage
    -- number of hits before projectile dies
    self.hits = PROJECTILE_DEFS[self.name].hits
end

function Projectile:update(dt, map)
    -- update position
    self.x = self.x + (self.dx * dt)
    self.y = self.y + (self.dy * dt) 

    --update lifetime
    self.lifetime = self.lifetime - dt
end

-- target must be an entity
function Projectile:hit(target, attackboost)
    local boost = 1
    for i, bonus in pairs(attackboost) do
        if bonus.tag == PROJECTILE_DEFS[self.name].type or bonus.tag == 'any' then
            boost = boost * bonus.num
        end
    end
    
    target:damage(PROJECTILE_DEFS[self.name].damage * boost, PROJECTILE_DEFS[self.name].push, self, PROJECTILE_DEFS[self.name].inflictions)
    self.hits = self.hits - 1
end

function Projectile:render(camera)
    --debug: hitbox
    -- love.graphics.rectangle('line', math.floor(self.x - camera.x),  math.floor(self.y - camera.y), self.width, self.height)
    love.graphics.draw(gTextures[PROJECTILE_DEFS[self.name].texture], 
        gFrames[PROJECTILE_DEFS[self.name].texture][PROJECTILE_DEFS[self.name].frames[self.frame]],
        math.floor(self.x - camera.x), math.floor(self.y - camera.y))
end

--gets the starting position of a projectile
function GetStartPosition(holder)
     -- calculate starting position and rotation of the sword
     local pos = {x = holder.x, y = holder.y, dx = 0, dy = 0}
     if holder.direction == 'up' then
         pos.x = holder.x - 3
         pos.y = holder.y - 18
         pos.dy = -1
     elseif holder.direction == 'right' then
         pos.x = holder.x + 10
         pos.dx = 1
     elseif holder.direction == 'down' then
         pos.x = holder.x - 3
         pos.y = holder.y + 10
         pos.dy = 1
     elseif holder.direction == 'left' then
         pos.x = holder.x - 16
         pos.dx = -1
     end

     return pos
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
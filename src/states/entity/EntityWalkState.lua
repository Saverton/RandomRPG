--[[
    Walk State: when an entity is moving
    @author Saverton
]]

EntityWalkState = Class{__includes = EntityBaseState}

function EntityWalkState:init(entity)
    self.entity = entity

    self.animate = true

    self.entity:changeAnimation('walk-' .. entity.direction)
end

function EntityWalkState:update(dt)
    local oldX, oldY = self.entity.x, self.entity.y
    if self.entity.direction == 'up' then
        self.entity.y = self.entity.y - (self.entity.speed * dt)
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + (self.entity.speed * dt)
    elseif self.entity.direction == 'down' then
        self.entity.y = self.entity.y + (self.entity.speed * dt)
    elseif self.entity.direction == 'left' then
        self.entity.x = self.entity.x - (self.entity.speed * dt)
    end

    -- if the movement causes a collision, move the entity back to its old spot, that way they can move next frame without having to back up.
    if (self:checkCollision()) then
        self.entity.x, self.entity.y = oldX, oldY
    end

    -- keep entity on map
    local size = self.entity.level.map.size
    if self.entity.x < 0 then
        self.entity.x = 0
    elseif self.entity.x + self.entity.width > (size * TILE_SIZE) then
        self.entity.x = math.floor((size * TILE_SIZE) - self.entity.width)
    end

    if self.entity.y < 0 then
        self.entity.y = 0
    elseif self.entity.y + self.entity.height > (size * TILE_SIZE) then
        self.entity.y = math.floor((size * TILE_SIZE) - self.entity.height)
    end
end

function EntityWalkState:checkCollision()
    local ent = self.entity
    local tilesToCheck = {}
    -- add one to each to match feature map indexes
    local mapX, mapY, mapXB, mapYB = math.floor((ent.x + PLAYER_HITBOX_X_OFFSET) / TILE_SIZE) + 1, math.floor((ent.y + PLAYER_HITBOX_Y_OFFSET) / TILE_SIZE) + 1, 
        math.floor((ent.x + ent.width + PLAYER_HITBOX_XB_OFFSET) / TILE_SIZE) + 1, math.floor((ent.y + ent.height + PLAYER_HITBOX_YB_OFFSET) / TILE_SIZE) + 1
    local collide = false

    if ent.direction == 'up' then
        tilesToCheck = {{mapX, mapY}, {mapXB, mapY} }
    elseif ent.direction == 'right' then
        tilesToCheck = {{mapXB, mapY}, {mapXB, mapYB}}
    elseif ent.direction == 'down' then
        tilesToCheck = {{mapX, mapYB}, {mapXB, mapYB}}
    elseif ent.direction == 'left' then
        tilesToCheck = {{mapX, mapY}, {mapX, mapYB}}
    end

    for i, coord in pairs(tilesToCheck) do
        if coord[1] < 1 or coord[1] > ent.level.map.size or coord[2] < 1 or coord[2] > ent.level.map.size then
            goto continue
        end
        local feature = ent.level.map.featureMap[coord[1]][coord[2]]
        if feature ~= nil and feature.isSolid then
            collide = true
            break
        end
        ::continue::
    end

    return collide
end
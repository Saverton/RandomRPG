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
    if not(self:checkCollision()) then
        if self.entity.direction == 'up' then
            self.entity.y = self.entity.y - (self.entity.speed * dt)
        elseif self.entity.direction == 'right' then
            self.entity.x = self.entity.x + (self.entity.speed * dt)
        elseif self.entity.direction == 'down' then
            self.entity.y = self.entity.y + (self.entity.speed * dt)
        elseif self.entity.direction == 'left' then
            self.entity.x = self.entity.x - (self.entity.speed * dt)
        end
    end

    -- keep entity on map
    if self.entity.x < 0 then
        self.entity.x = 0
    elseif self.entity.x + self.entity.width > (self.entity.level.map.size * TILE_SIZE) then
        self.entity.x = math.floor((self.level.map.size * TILE_SIZE) - self.entity.width)
    end

    if self.entity.y < 0 then
        self.entity.y = 0
    elseif self.entity.y + self.entity.height > (self.entity.level.map.size * TILE_SIZE) then
        self.entity.y = math.floor((self.level.map.size * TILE_SIZE) - self.entity.height)
    end
end

function EntityWalkState:checkCollision()
    local ent = self.entity
    local tilesToCheck = {}
    local mapX, mapY, mapXB, mapYB = math.floor(ent.x / TILE_SIZE), math.floor(ent.y / TILE_SIZE), 
        math.floor((ent.x + ent.width) / TILE_SIZE), math.floor((ent.y + ent.height) / TILE_SIZE)
    local collide = false
    print(tostring(mapX) .. ', ' .. tostring(mapY) .. ', ' .. tostring(mapXB) .. ', ' .. tostring(mapYB))

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
        print(tostring(coord[1]) .. ', ' .. tostring(coord[2]))
        if coord[1] < 1 or coord[1] > ent.level.map.size or coord[2] < 1 or coord[2] > ent.level.map.size then
            goto continue
        end
        local feature = ent.level.map.featureMap[coord[1] + 1][coord[2] + 1]
        if feature ~= nil and feature.isSolid then
            collide = true
            break
        end
        ::continue::
    end

    return collide
end
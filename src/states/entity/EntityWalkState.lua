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
    if self.entity.direction == 'up' then
        self.entity.y = self.entity.y - (self.entity.speed * dt)
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + (self.entity.speed * dt)
    elseif self.entity.direction == 'down' then
        self.entity.y = self.entity.y + (self.entity.speed * dt)
    elseif self.entity.direction == 'left' then
        self.entity.x = self.entity.x - (self.entity.speed * dt)
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
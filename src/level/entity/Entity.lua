--[[
    Base class for all entities in the game.
    attributes: x, y, width, height, stateMachine, animations, hp, speed, defense, onDeath(), direction, currentFrame,
        animationTimer
    @author Saverton
]]

Entity = Class{}

function Entity:init(def, level, pos, off)
    --positioning
    if off == nil then
        off = {
            x = 0,
            y = 0
        }
    end
    self.x = (((pos.x - 1) * TILE_SIZE) + (off.x))
    self.y = (((pos.y - 1) * TILE_SIZE) + (off.y))
    self.width = def.width or DEFAULT_ENTITY_WIDTH
    self.height = def.height or DEFAULT_ENTITY_HEIGHT
    self.direction = START_DIRECTION

    -- reference to level
    self.level = level or nil
    
    -- owned stateMachine
    self.stateMachine = nil

    -- animations
    self.animations = def.animations
    self.currentAnimation = def.startAnim or 'idle-right'
    self.currentFrame = 1
    self.timeSinceLastFrame = 0

    -- combat statistics
    self.hp = def.hp or DEFAULT_HP
    self.attack = def.attack or DEFAULT_ATTACK
    self.speed = def.speed or DEFAULT_SPEED
    self.defense = def.defense or DEFAULT_DEFENSE

    self.hpboost = def.hpboost or {}
    self.attackboost = def.attackboost or {}
    self.speedboost = def.speedboost or {}
    self.defenseboost = def.defenseboost or {}

    self.currenthp = self.hp

    self.effects = {} -- currently applied effects
    self.inflictions = def.inflictions or {} -- effects that are inflicted upon attack
    self.immunities = def.immunities or {} -- effects that this entity is immune to being afflicted by

    -- reference to owned projectiles
    self.projectiles = {}

    self.onDeath = def.onDeath or function() end

    -- attack/defense management
    self.invincible = false
    self.invincibleTimer = 0
    self.flashCounter = 0
    self.canAttack = true

    -- push management
    self.pushed = false
    self.pushdx = 0
    self.pushdy = 0
end

function Entity:update(dt)
    self.stateMachine:update(dt)

    --update effects
    local removeEffect = {}
    for i, effect in pairs(self.effects) do
        effect:update(dt)
        if effect.duration <= 0 then
            table.insert(removeEffect, i)
        end
    end
    for i, index in pairs(removeEffect) do
        table.remove(self.effects, index)
    end

    --update projectiles
    local removeIndex = {}
    for i, projectile in pairs(self.projectiles) do
        projectile:update(dt)
        for i, entity in pairs(self.level.enemySpawner.entities) do
            if Collide(projectile, entity) then
                projectile:hit(entity, self.attackboost)
            end
        end
        if projectile.hits <= 0 or projectile.lifetime <= 0 or GetDistance(projectile, self.level.player) > DESPAWN_RANGE then
            table.insert(removeIndex, i)
        end
    end
    --remove dead projectiles
    for i, index in pairs(removeIndex) do
        table.remove(self.projectiles, index)
    end

    -- update frames
    if #self.animations[self.currentAnimation].frames > 1 then
        self:updateFrames(dt)
    end

    --update flash counter and invincibleTimer
    if self.invincible then
        self.invincibleTimer = self.invincibleTimer - dt
        self.flashCounter = self.flashCounter + 1
        if self.invincibleTimer <= 0 then
            self.invincible = false
            self.invincibleTimer = 0
            self.flashCounter = 0
        end
    end

    --update push
    if self.pushed then
        local oldx, oldy = self.x, self.y
        self.x = self.x + self.pushdx
        self.y = self.y + self.pushdy
        self.pushdx = math.max(0, math.floor(self.pushdx / 2))
        self.pushdy = math.max(0, math.floor(self.pushdy / 2))
        if self.pushdx == 0 and self.pushdy == 0 then
            self.pushed = false
            self:changeState('idle')
        end
        if self:checkCollision() then
            self.x, self.y = oldx, oldy
        end
    end
end

function Entity:changeState(name, params)
    self.stateMachine:change(name, params)
end

function Entity:changeAnimation(name)
    assert(self.animations[name])
    self.currentAnimation = name
    self.currentFrame = 1
end

function Entity:updateFrames(dt)
    -- update frames
    local anim = self.animations[self.currentAnimation]
    self.timeSinceLastFrame = self.timeSinceLastFrame + dt
    if self.timeSinceLastFrame > anim.interval then
        self.currentFrame = self.currentFrame + 1
        if self.currentFrame > #anim.frames then
            self.currentFrame = 1
        end
        self.timeSinceLastFrame = 0
    end
end

function Entity:collides(target)
    return Collide(self, target)
end

function Entity:damage(amount)
    if not self.invincible then
        love.audio.play(gSounds['hit_1'])
        self.currenthp = math.max(0, self.currenthp - (math.max(1, amount - self:getDefense())))
        self:goInvincible()
        return true
    end
    return false
end

function Entity:push(strength, from)
    if not self.pushed then
        self.pushed = true
        self.pushdx, self.pushdy = 0, 0
        local dx, dy = (self.x + (math.floor(self.width / 2))) - (from.x + (math.floor(from.width / 2))),
            (self.y + (math.floor(self.height / 2))) - (from.y + (math.floor(from.height / 2)))
        self.pushdx = (dx / (math.abs(dx) + math.abs(dy))) * strength
        self.pushdy = (dy / (math.abs(dx) + math.abs(dy))) * strength
    end
end

function Entity:inflict(inflictions)
    for i, effect in pairs(inflictions) do
        if not Contains(self.immunities, effect.name) then
            if not ContainsName(self.effects, effect.name) then
                -- add new effect
                table.insert(self.effects, Effect(effect.name, effect.duration, self))
            else
                --reset duration of effect if already held
                self.effects[GetIndex(self.effects, effect.name)].duration = effect.duration
            end
        end
    end
end

function Entity:goInvincible()
    self.invincible = true
    self.invincibleTimer = INVINCIBLE_TIME
end

function Entity:render(camera, offsetX, offsetY)
    -- determine the on screen x and y positions of the entity based on the camera, any
    -- drawing manipulation, or offsets.
    local xScale = self.animations[self.currentAnimation].xScale or 1
    if offsetX == nil then
        offsetX = 0
    end
    if offsetY == nil then
        offsetY = 0
    end
    local onScreenX = math.floor(self.x - camera.x + (xScale * offsetX))
    local onScreenY = math.floor(self.y - camera.y + offsetY)

    -- fix player sprite being off by 16 pixels
    if xScale == -1 then
        onScreenX = onScreenX + self.width
    end

    -- draw the entity at the specified x and y.
    if self.flashCounter == FLASH_FRAME then
        local r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(r, g, b, 0)
        self.flashCounter = 0
    end
    self.stateMachine:render(onScreenX, onScreenY)
    love.graphics.setColor(1, 1, 1, 1)

    --draw the projectiles
    for i, projectile in pairs(self.projectiles) do
        projectile:render(camera)
    end

    -- draw effects
    for i, effect in pairs(self.effects) do
        effect:render(camera)
    end

    -- draw the health bar
    onScreenX = math.floor(self.x - camera.x + offsetX)
    onScreenY = math.floor(self.y - camera.y + offsetY)
    self:drawHealthBar(onScreenX, onScreenY)
end

function Entity:drawHealthBar(entityX, entityY)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', entityX - 1, entityY - 7, HEALTH_BAR_WIDTH + 2, HEALTH_BAR_HEIGHT + 2)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('fill', entityX, entityY - 6, HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('fill', entityX, entityY - 6, (self.currenthp / self:getHp()) * HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)
end

function Entity:checkCollision()
    local tilesToCheck = {}
    -- add one to each to match feature map indexes
    local mapX, mapY, mapXB, mapYB = math.floor((self.x + PLAYER_HITBOX_X_OFFSET) / TILE_SIZE) + 1, math.floor((self.y + PLAYER_HITBOX_Y_OFFSET) / TILE_SIZE) + 1, 
        math.floor((self.x + self.width + PLAYER_HITBOX_XB_OFFSET) / TILE_SIZE) + 1, math.floor((self.y + self.height + PLAYER_HITBOX_YB_OFFSET) / TILE_SIZE) + 1
    local collide = false

    if self.direction == 'up' then
        tilesToCheck = {{mapX, mapY}, {mapXB, mapY} }
    elseif self.direction == 'right' then
        tilesToCheck = {{mapXB, mapY}, {mapXB, mapYB}}
    elseif self.direction == 'down' then
        tilesToCheck = {{mapX, mapYB}, {mapXB, mapYB}}
    elseif self.direction == 'left' then
        tilesToCheck = {{mapX, mapY}, {mapX, mapYB}}
    end

    for i, coord in pairs(tilesToCheck) do
        if coord[1] < 1 or coord[1] > self.level.map.size or coord[2] < 1 or coord[2] > self.level.map.size then
            goto continue
        end
        local feature = self.level.map.featureMap[coord[1]][coord[2]]
        local tile = self.level.map.tileMap.tiles[coord[1]][coord[2]]
        if (feature ~= nil and FEATURE_DEFS[feature.name].isSolid) or tile.barrier then
            collide = true
            break
        end
        ::continue::
    end

    return collide
end

function Entity:getDamage()
    local boost = 1
    for i, bonus in pairs(self.attackboost) do
        if bonus.tag == 'melee' or bonus.tag == 'normal' then
            boost = boost * bonus.num
        end
    end
    return self.attack * boost
end

function Entity:getHp()
    local boost = 1
    for i, bonus in pairs(self.hpboost) do
        boost = boost * bonus
    end
    return self.hp * boost
end

function Entity:getSpeed()
    local boost = 1
    for i, bonus in pairs(self.speedboost) do
        boost = boost * bonus.num
    end
    return self.speed * boost
end

function Entity:getDefense()
    local boost = 1
    for i, bonus in pairs(self.defenseboost) do
        boost = boost * bonus
    end
    return self.defense * boost
end
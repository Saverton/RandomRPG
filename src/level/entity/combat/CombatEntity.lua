--[[
    Combat Entity: any entity that performs attacks or receives damage
    @author Saverton
]]

CombatEntity = Class{__includes = Entity}

function CombatEntity:init(def, level, pos)
    Entity.init(self, def, level, pos)

    -- combat statistics
    self.hp = def.hp or DEFAULT_HP
    self.attack = def.attack or DEFAULT_ATTACK
    self.defense = def.defense or DEFAULT_DEFENSE
    self.magic = def.magic or DEFAULT_MAGIC
    -- stat boosts
    self.boosts = def.boosts or {hp = {}, atk = {}, spd = {}, def = {}, mag = {}}
    -- current values for depletable stats
    self.currenthp = def.currenthp or self:getHp()
    self.currentmagic = def.currentmagic or self:getMagic()

    -- status effect management
    self.effects = def.effects or {} -- currently applied effects
    self.inflictions = def.inflictions or {} -- effects that are inflicted upon attack
    self.immunities = def.immunities or {} -- effects that this entity is immune to being afflicted by

    -- reference to owned projectiles
    self.projectileManager = ProjectileManager(self, def.projectiles or {})

    -- attack/defense management
    self.invincible = false
    self.invincibleTimer = 0
    self.flashCounter = 0
    self.canUseItem = true

    -- push management
    self.pushed = false
    self.pushdx = 0
    self.pushdy = 0

    -- level system
    self.statLevel = StatLevel(self, def.statLevel or {level = 0})

    -- ranged ammo
    self.ammo = def.ammo or START_AMMO
end

function CombatEntity:update(dt)
    Entity.update(self, dt)

    self.projectileManager:update(dt)

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
        local modx, mody = (self.pushdx / math.abs(self.pushdx)), (self.pushdy / math.abs(self.pushdy))
        self.pushdx = math.floor(math.abs(self.pushdx) / PUSH_DECAY)
        self.pushdy = math.floor(math.abs(self.pushdy) / PUSH_DECAY)
        if self.pushdx > 0 then
            self.pushdx = self.pushdx * modx
        end
        if self.pushdy > 0 then
            self.pushdy = self.pushdy * mody
        end
        if self.pushdx == 0 and self.pushdy == 0 then
            self.pushed = false
        end
        if self:checkCollision() then
            self.x, self.y = oldx, oldy
        end
    end

    --regen magic
    if self.currentmagic ~= self:getMagic() then
        self.currentmagic = math.min(self:getMagic(), self.currentmagic + ((ENTITY_DEFS[self.name].magicRegenRate or 0) * dt))
    end
end

function CombatEntity:damage(amount, pushStrength, pushFrom, inflictions)
    self:push(pushStrength, pushFrom)
    self:hurt(amount)
    self:inflict(inflictions)
end

function CombatEntity:hurt(amount)
    if not self.invincible then
        love.audio.play(gSounds['hit_1'])
        local defense = self:getDefense()
        if defense >= amount then
            defense = math.max(amount - 1, 0)
        end
        self.currenthp = math.max(0, self.currenthp - (amount - defense))
        self:goInvincible()
        return true
    end
    return false
end

function CombatEntity:heal(amount)
    self.currenthp = math.min(self:getHp(), math.floor(self.currenthp + amount))
end

function CombatEntity:revive()
    local maxHp = self:getHp()
    while self.currenthp ~= maxHp do
        self:heal(1)
    end
end

function CombatEntity:push(strength, from)
    if not self.pushed and not self.invincible then
        self.pushed = true
        self.pushdx, self.pushdy = 0, 0
        local dx, dy = (self.x + (math.floor(self.width / 2))) - (from.x + (math.floor(from.width / 2))),
            (self.y + (math.floor(self.height / 2))) - (from.y + (math.floor(from.height / 2)))
        self.pushdx = (dx / (math.abs(dx) + math.abs(dy))) * strength
        self.pushdy = (dy / (math.abs(dx) + math.abs(dy))) * strength
    end
end

function CombatEntity:inflict(inflictions)
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

function CombatEntity:goInvincible()
    self.invincible = true
    self.invincibleTimer = INVINCIBLE_TIME
end

function CombatEntity:render(camera)
    -- set opacity to reflect flash counter
    if self.flashCounter == FLASH_FRAME then
        local r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(r, g, b, 0)
        self.flashCounter = 0
    end

    -- render entity
    Entity.render(self, camera)

    -- draw projectiles
    self.projectileManager:render(camera)

    -- draw effects
    for i, effect in pairs(self.effects) do
        effect:render(camera)
    end
end

function CombatEntity:getHp()
    local boost = 1
    for i, bonus in pairs(self.boosts.hp) do
        boost = boost * bonus.num
    end
    return math.floor(self.hp * boost)
end

function CombatEntity:getAttack()
    local boost = 1
    for i, bonus in pairs(self.boosts.atk) do
        boost = boost * bonus.num
    end
    return self.attack * boost
end

function CombatEntity:getSpeed()
    local boost = 1
    for i, bonus in pairs(self.boosts.spd) do
        boost = boost * bonus.num
    end
    return math.floor(self.speed * boost)
end

function CombatEntity:getDefense()
    local boost = 1
    for i, bonus in pairs(self.boosts.atk) do
        boost = boost * bonus.num
    end
    return math.floor(self.defense * boost)
end

function CombatEntity:getMagic()
    local boost = 1
    for i, bonus in pairs(self.boosts.mag) do
        boost = boost * bonus.num
    end
    return math.floor(self.magic * boost)
end

function CombatEntity:useAmmo(amount)
    local haveEnough = false
    if (amount <= self.ammo) then
        self.ammo = self.ammo - amount
        haveEnough = true
    end
    return haveEnough
end

function CombatEntity:useMagic(amount)
    local haveEnough = false
    if (amount <= math.floor(self.currentmagic)) then
        self.currentmagic = math.floor(self.currentmagic - amount)
        haveEnough = true
    end
    return haveEnough
end

function CombatEntity:dies()
    love.audio.play(gSounds[ENTITY_DEFS[self.name].deathSound or 'enemy_dies_1'])
    self.level:throwFlags({'kill entity', 'kill ' .. self.name})
end

function CombatEntity:getDisplayMessage()
    -- return a string with basic info about this entity
    return ('LVL ' .. tostring(self.statLevel.level) .. ' ' .. ENTITY_DEFS[self.name].displayName .. 
        ': (' .. tostring(self.currenthp) .. ' / ' .. tostring(self:getHp()) .. ')')
end
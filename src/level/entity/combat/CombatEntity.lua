--[[
    Combat Entity: definitions for behavior of any entity that can cause/receive damage. It can cause and inflict effects, can hold references
    to projectiles, has invincibility timers for when it is hit, can be pushed, has a statLevel, and has an ammo count.
    @author Saverton
]]

CombatEntity = Class{__includes = Entity}

function CombatEntity:init(level, definitions, position)
    Entity.init(self, level, definitions, position) -- initiate an entity
    self.combatStats = {
        maxHp = definitions.combatStats.maxHp or DEFAULT_HP, -- the default maximum health points
        attack = definitions.combatStats.attack or DEFAULT_ATTACK, -- the default attack damage caused by this combatEntity
        defense = definitions.combatStats.defense or DEFAULT_DEFENSE, -- the default damage resistance
        maxMana = definitions.combatStats.maxMana or DEFAULT_MAGIC -- the default maximum mana
    } -- combatEntity's combat statistics
    self.boosts = {maxHp = {}, attack = {}, speed = {}, defense = {}, maxMana = {}} -- combatEntity's stat boost table, starts as empty
    self.currentStats = {
        hp = definitions.currentStats.hp or self.combatStats.maxHp, -- the current hp value, starts at max by default
        mana = definitions.currentStats.mana or self.combatStats.maxMana -- the current mana, starts at max by default
    } -- combatEntity's current Stats for depletable statistics
    self.effectManager = EffectManager(self, definitions.effectManager or {}) -- status effect manager
    self.projectileManager = ProjectileManager(self, definitions.projectiles or {}) -- manager for all owned projectiles
    self.invincibilityManager = InvincibilityManager() -- manages invincibility after being hit
    self.pushManager = PushManager(self) -- manages pushes from attacks
    self.statLevel = StatLevel(self, definitions.statLevel or {level = 0}) -- manages the statLevel of this combatEntity
    self.stateMachine = StateMachine({
        ['idle'] = function() return PlayerIdleState(self) end,
        ['walk'] = function() return PlayerWalkState(self, self.level) end,
        ['interact'] = function() return EntityInteractState(self) end
    }) -- initiate a state machine and set state to idle
    self:changeState('idle')
end

-- update each of the components of this Combat Entity
function CombatEntity:update(dt)
    Entity.update(self, dt) -- update the entity
    self.projectileManager:update(dt)
    self.effectManager:update(dt)
    self.invincibilityManager:update(dt)
    self.pushManager:update(dt)
    self:regenMana(dt) -- regenerate mana to use magic items
end

-- render the combatEntity
function CombatEntity:render(camera)
    local onScreenX, onScreenY = self:getOnScreenPosition()
    love.graphics.setColor(self.invincibilityManager:getCurrentColor()) -- sets opacity to reflect flash counter
    Entity.render(self, camera) -- render entity
    self.projectileManager:render(camera) -- render owned projectiles
    self.effectManager:render(onScreenX, onScreenY) -- render effects
end

-- if the current mana level is below the maximum, regenerate mana
function CombatEntity:regenMana(dt)
    if self.currentStats.mana ~= self:getMaxMana() then
        self.currentStats.mana = math.min(self:getMaxMana(), self.currentStats.mana + ((ENTITY_DEFS[self.name].manaRegenRate or 0) * dt))
    end
end

-- damage the combat entity by pushing it, hurting it, and inflicting effects on it
function CombatEntity:damage(amount, push, inflictions)
    self.pushManager:push(push.strength, push.direction) -- push the entity
    self:hurt(amount) -- hurt the entity
    self.effectManager:inflict(inflictions) -- inflict effects
end

-- hurt the combat entity; return true if it is hurt, false otherwise (if it is invincible)
function CombatEntity:hurt(amount)
    if not self.invincibilityManager.invincible then
        love.audio.play(gSounds['combat'][ENTITY_DEFS[self.name].hitSound or 'hit']) -- play hit sound
        local defense = self:getDefense() -- get damage reduction from defense
        if defense >= amount then
            defense = math.max(amount - 1, 0) -- ensure that defense never reduces damage to 0
        end
        self.currentStats.hp = math.max(0, self.currentStats.hp - (amount - defense))
        self.invincibilityManager:goInvincible()
        return true -- return that the entity is hurt
    end
    return false -- return  that the entity is not hurt
end

-- heal the combat entity by a certain amount
function CombatEntity:heal(amount)
    gSounds['items']['health']:play()
    self.currenthp = math.min(self:getHp(), math.floor(self.currenthp + amount))
end

-- totally heal the combat entity
function CombatEntity:totalHeal()
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
-- return this entity's max hp with boosts
function CombatEntity:getMaxHp()
    return math.floor(self.combatStats.maxHp * ProductOfBoosts(self.boosts.hp))
end
-- return this entity's attack with boosts
function CombatEntity:getAttack()
    return math.floor(self.combatStats.attack * ProductOfBoosts(self.boosts.attack))
end
-- return this entity's speed with boosts
function CombatEntity:getSpeed()
    return math.floor(self.speed * ProductOfBoosts(self.boosts.speed))
end
-- return this entity's defense with boosts
function CombatEntity:getDefense()
    return math.floor(self.combatStats.defense * ProductOfBoosts(self.boosts.defense))
end
-- return this entity's max mana with boosts
function CombatEntity:getMaxMana()
    return math.floor(self.combatStats.maxMana * ProductOfBoosts(self.boosts.maxMana))
end

-- use ammunition, return true if there was enough, false otherwise
function CombatEntity:useAmmo(amount)
    local successful = false
    local index = GetIndex(self.items, 'ammo')
    if index ~= -1 and self.items[index].quantity >= amount then -- check if the entity has any ammo
        self.items[index].quantity = self.items[index].quantity - amount -- deplete ammo by amount
        successful = true
    end
    return successful
end

-- return true if mana was used correctly, false otherwise
function CombatEntity:useMana(amount)
    local successful = false
    if (amount <= math.floor(self.currentStats.mana)) then -- determine if have enough mana
        self.currentStats.mana = math.floor(self.currentStats.mana - amount) -- deplete mana by amount
        successful = true
    end
    return successful
end

-- function called on entity death, plays sound and throws flags
function CombatEntity:dies()
    love.audio.play(gSounds['combat'][ENTITY_DEFS[self.name].deathSound or 'enemy_dies']) -- play death sound
    self.level:throwFlags({'kill entity', 'kill ' .. self.name})
end

-- return a string with basic info about this entity
function CombatEntity:getDisplayMessage()
    return ('LVL ' .. tostring(self.statLevel.level) .. ' ' .. ENTITY_DEFS[self.name].displayName .. 
        ': (' .. tostring(self.currenthp) .. ' / ' .. tostring(self:getHp()) .. ')')
end
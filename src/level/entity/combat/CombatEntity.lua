--[[
    Combat Entity: definitions for behavior of any entity that can cause/receive damage. It can cause and inflict effects, can hold references
    to projectiles, has invincibility timers for when it is hit, can be pushed, has a statLevel, and has an ammo count.
    @author Saverton
]]

CombatEntity = Class{__includes = Entity}

function CombatEntity:init(level, definitions, position)
    Entity.init(self, level, definitions, position) -- initiate an entity
    self.combatStats = {
        ['maxHp'] = definitions.combatStats['maxHp'] or DEFAULT_HP, -- the default maximum health points
        ['attack'] = definitions.combatStats['attack'] or DEFAULT_ATTACK, -- the default attack damage caused by this combatEntity
        ['defense'] = definitions.combatStats['defense'] or DEFAULT_DEFENSE, -- the default damage resistance
        ['maxMana'] = definitions.combatStats['maxMana'] or DEFAULT_MAGIC -- the default maximum mana
    } -- combatEntity's combat statistics
    self.boosts = {['maxHp'] = {}, ['attack'] = {}, ['speed'] = {}, ['defense'] = {}, ['maxMana'] = {}} -- combatEntity's stat boost table, starts as empty
    self.currentStats = {
        hp = (definitions.currentStats or {}).hp or self.combatStats['maxHp'], -- the current hp value, starts at max by default
        mana = (definitions.currentStats or {}).mana or self.combatStats['maxMana'] -- the current mana, starts at max by default
    } -- combatEntity's current Stats for depletable statistics
    self.effectManager = EffectManager(self, definitions.effectManager or {}) -- status effect manager
    self.projectileManager = ProjectileManager(self) -- manager for all owned projectiles
    self.invincibilityManager = InvincibilityManager() -- manages invincibility after being hit
    self.pushManager = PushManager(self) -- manages pushes from attacks
    self.statLevel = StatLevel(self, definitions.statLevel) -- manages the statLevel of this combatEntity
end

-- update each of the components of this Combat Entity
function CombatEntity:update(dt)
    self.stateMachine:update(dt) -- update the entity's statemachine, where most activity is held
    self.animator:update(dt) -- update the entity's animation
    if self.items[self.heldItem] ~= nil then
        self.items[self.heldItem]:update(dt) --update held item's use timer
    end
    self.projectileManager:update(dt)
    self.effectManager:update(dt)
    self.invincibilityManager:update(dt)
    self.pushManager:update(dt)
    self:regenMana(dt) -- regenerate mana to use magic items
end

-- render the combatEntity
function CombatEntity:render(camera)
    local onScreenX, onScreenY = self:getOnScreenPosition(camera)
    love.graphics.setColor(self.invincibilityManager:getCurrentColor()) -- sets opacity to reflect flash counter

    if self.direction == 'down' then
        Entity.render(self, camera)
        self.projectileManager:render(camera)
    else
        self.projectileManager:render(camera)
        Entity.render(self, camera)
    end

    self.effectManager:render(onScreenX, onScreenY) -- render effects
end

-- if the current mana level is below the maximum, regenerate mana
function CombatEntity:regenMana(dt)
    if self.currentStats.mana ~= self:getStat('maxMana') then
        self.currentStats.mana = math.min(self:getStat('maxMana'), self.currentStats.mana + ((ENTITY_DEFS[self.name].manaRegenRate or 0) * dt))
        self:updateStatBars()
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
        local defense = self:getStat('defense') -- get damage reduction from defense
        if defense >= amount then
            defense = math.max(amount - 1, 0) -- ensure that defense never reduces damage to 0
        end
        self.currentStats.hp = math.max(0, self.currentStats.hp - (amount - defense))
        if self.currentStats.hp <= 0 then
            self:dies() -- call death function
        end
        self.invincibilityManager:goInvincible()
        self:updateStatBars() -- update the health bar
        return true -- return that the entity is hurt
    end
    return false -- return  that the entity is not hurt
end

-- heal the combat entity by a certain amount
function CombatEntity:heal(amount)
    gSounds['items']['health']:play()
    self.currentStats.hp = math.min(self:getStat('maxHp'), math.floor(self.currentStats.hp + amount)) -- set the current hp to either the max or the current plus amount
    self:updateStatBars() -- update the health bar
end

-- totally heal the combat entity
function CombatEntity:totalHeal()
    local maxHp = self:getStat('maxHp')
    while self.currentStats.hp ~= maxHp do
        self:heal(1) -- heal by one until the entity's max hp is reached
    end
end

-- return this entity's combat statistic with boosts
function CombatEntity:getStat(statName)
    return math.floor(self.combatStats[statName] * ProductOfBoosts(self.boosts[statName]))
end
-- return this entity's speed with boosts
function CombatEntity:getSpeed()
    return math.floor(self.speed * ProductOfBoosts(self.boosts['speed']))
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
        self:updateStatBars() -- update mana bar
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
        ': (' .. tostring(self.currentStats.hp) .. ' / ' .. tostring(self:getStat('maxHp')) .. ')')
end

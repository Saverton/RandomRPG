--[[
    Enemy class: Non-player combat entities, only have a health bar, have a color, have a target which they seek when pathfinding.
    @author Saverton
]]

Enemy = Class{__includes = CombatEntity}

function Enemy:init(level, definition, instance, manager)
    CombatEntity.init(self, level, definition, instance.position) -- initiate the combat entity
    self.manager = manager -- reference to entity manager
    self.target = nil -- target which the entity will seek out
    self.color = ENEMY_COLORS[math.min(#ENEMY_COLORS, self.statLevel.level)] -- color of the enemy, based on its level
    self.hpBar = ProgressBar({x = self.x, y = self.y - 6, width = BAR_WIDTH, height = BAR_HEIGHT}, {1, 0, 0, 0.75}) -- progress bar tracking health
    self.hpBar:updateRatio(self.currentStats.hp / self:getStat('maxHp'))
    self.statLevel:levelUpTo(math.random(math.max(1, self.level.player.statLevel.level - 2), self.level.player.statLevel.level)) -- level up enemy
    self.active = false -- enemy doesn't attack or find targets if not active. 
    self.hasKey = instance.hasKey or false -- whether or not the enemy has a key.
    self.drops = self:generateDrops() -- generates the list of items that the enemy will drop
    self.stateMachine = StateMachine({
        ['idle'] = function() return EnemyIdleState(self) end,
        ['walk'] = function() return EnemyWalkState(self, self.level) end,
        ['interact'] = function() return EntityInteractState(self) end,
        ['spawn'] = function() return EnemySpawnState(self) end,
        ['despawn'] = function() return EnemyDespawnState(self) end
    }) -- initiate a state machine and set state to spawn
    self:changeState('spawn')
    self.aiSubType = 'wander'
    self:getEnemyInventory(definition.items or {})
end

-- update the enemy
function Enemy:update(dt)
    CombatEntity.update(self, dt) -- update combatentity components
    if self.active and self.currentStats.hp > 0 then
        self:seekTarget() -- try to find or track down a target
    end
end

-- render the enemy on screen
function Enemy:render(camera)
    local onScreenX, onScreenY = math.floor(self.x - camera.x + self.xOffset), math.floor(self.y - camera.y + self.yOffset - 4)
    if self.hasKey and self.currentStats.hp > 0 then -- render a key behind the enemy if it holds a key
        love.graphics.draw(gTextures['items'], gFrames['items'][11], onScreenX, onScreenY) -- draw a key
    end
    love.graphics.setColor(self.color) -- set the color to the enemy's color
    CombatEntity.render(self, camera) -- draw the entity onscreen
    if self:statsVisible() and self.currentStats.hp > 0 then
        self.hpBar:render(onScreenX, onScreenY) -- render the hp bar
        self:renderAggression(onScreenX, onScreenY) -- draw a little '!' if aggressive
    end
end

-- seek out a target if doesn't already have one, if it does check collisions and distance for de-agro
function Enemy:seekTarget()
    if self.target == nil then
        self:findTarget(self.level.player) -- attempt to find a target player
    else
        if Collide(self, self.target) then --check if damage target by running into it
            self.target:damage(self:getStat('attack'), {strength = ENTITY_DEFS[self.name].push, direction = self.direction}, self.effectManager.inflictions)
        end
        if GetDistance(self, self.target) > ENTITY_DEFS[self.name].aggressiveDistance * TILE_SIZE then
            self:loseTarget() -- check if target is out of agro Range, if so, lose target
        end
    end
end

-- search for a target entity, if found, play a sound and set aggressive speed boost
function Enemy:findTarget(entity)
    if GetDistance(self, entity) <= ENTITY_DEFS[self.name].aggressiveDistance * TILE_SIZE then -- if the entity is within the aggressive range
        gSounds['combat']['target_found']:play() -- play aggressive sound
        self.target = entity
        self.aiSubType = 'target' -- enter the targeting state of AI
        table.insert(self.boosts['speed'], {name = 'aggressive', multiplier = ENTITY_DEFS[self.name].aggressiveSpeedBoost})
    end 
end

-- release the current target, remove speed boost
function Enemy:loseTarget()
    self.target = nil -- target is now undefined
    self.aiSubType = 'wander' -- return to wandering state
    table.remove(self.boosts['speed'], GetIndex(self.boosts['speed'], 'aggressive')) -- remove speed boost
end

-- draw an aggression marker if the enemy has a target at the specified x and y
function Enemy:renderAggression(x, y)
    if self.target ~= nil then
        love.graphics.setFont(gFonts['small'])
        love.graphics.setColor(1, 1, 0, 1)
        love.graphics.print('!', x - 3, y)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

-- called when the enemy dies: throws flags, drops any items, and gives player exp
function Enemy:dies()
    CombatEntity.dies(self) -- combat entity dies
    self.level:throwFlags{'kill enemy'} -- throws enemy specific flag
    self:dropItems() -- drops items according to its loot table
    self.level.player.statLevel:expGain(self.statLevel.level * ENTITY_DEFS[self.name].exp) -- give player exp for the kill
    self:changeState('despawn') -- change state to despawn state
end

-- generate the enemy's drop table
function Enemy:generateDrops()
    local drops = {} -- table of drops
    for i, item in pairs(ENTITY_DEFS[self.name].drops) do
        if math.random() < item.chance then -- go through each potential drop and check each one's chance against random number
            table.insert(drops, {name = item.name, x = self.x, y = self.y, quantity = math.random(item.min, item.max)})
        end
    end
    if self.hasKey then
        table.insert(drops, {name = 'key', x = self.x, y = self.y, quantity = 1}) -- add a key if the enemy holds a key
    end
    return drops -- return the table with all drops
end

-- generates a list of items to drop from enemy's loot table, then spawns pickups accordingly
function Enemy:dropItems()
    for i, drop in ipairs(self.drops) do
        drop.x, drop.y = self.x, self.y -- set all drops to drop at entity position
    end
    self.level.pickupManager:spawnPickups(self.drops) -- create pickups with each of the dropped items
end

-- update all progress bars
function Enemy:updateBars()
    self.hpBar:updateRatio(self.currentStats.hp / self:getStat('maxHp')) -- update hp bar
end

-- determine which item this enemy will hold given an item list for this enemy and this enemy's stat level
function Enemy:getEnemyInventory(items)
    self.items = {} -- set the item inventory to be empty
    local level = self.statLevel.level
    for i, item in ipairs(items) do -- go through each item in order
        local itemLevel = item.level or 1 -- the level at which this item is held by the entity
        if level >= itemLevel and math.random() < (item.chance or 1) then
            self:giveItem(Item(item.name, self, item.quantity)) -- give the item to the entity
            self:setHeldItem(#self.items) -- set the held item to this item
        end
    end
end

-- return whether or not this entity's stats should be shown
function Enemy:statsVisible()
    return self.active
end

-- spawn a new enemy appropriately according to the defined type
function Enemy.spawnEnemy(level, definition, instance, manager)
    local type = definition.type
    if (type == 'normal' or type == nil) then
        return Enemy(level, definition, instance, manager)
    elseif (type == 'camo') then
        return CamoEnemy(level, definition, instance, manager)
    end
end
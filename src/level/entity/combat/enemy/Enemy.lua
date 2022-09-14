--[[
    Enemy class: Non-player combat entities, only have a health bar, have a color, have a target which they seek when pathfinding.
    @author Saverton
]]

Enemy = Class{__includes = CombatEntity}

function Enemy:init(level, definition, position)
    CombatEntity.init(self, level, definition, position) -- initiate the combat entity
    self.target = nil -- target which the entity will seek out
    self.color = ENEMY_COLORS[math.min(#ENEMY_COLORS, self.statLevel.level)] -- color of the enemy, based on its level
    self.hpBar = ProgressBar({x = self.x, y = self.y - 6, width = BAR_WIDTH, height = BAR_HEIGHT}, {1, 0, 0, 0.75}) -- progress bar tracking health
    self.hpBar:updateRatio(self.currentStats.hp / self:getStat('maxHp'))
    self.statLevel:levelUpTo(math.random(math.max(1, self.level.player.statLevel.level - 2), self.level.player.statLevel.level)) -- level up enemy
    self.stateMachine = StateMachine({
        ['idle'] = function() return EnemyIdleState(self) end,
        ['walk'] = function() return EnemyWalkState(self, self.level) end,
        ['interact'] = function() return EntityInteractState(self) end
    }) -- initiate a state machine and set state to idle
    self:changeState('idle')
end

-- update the enemy
function Enemy:update(dt)
    CombatEntity.update(self, dt) -- update combatentity components
    self:seekTarget() -- try to find or track down a target
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

-- render the enemy on screen
function Enemy:render(camera)
    love.graphics.setColor(self.color) -- set the color to the enemy's color
    CombatEntity.render(self, camera) -- draw the entity onscreen
    local onScreenX, onScreenY = math.floor(self.x - camera.x + self.xOffset), math.floor(self.y - camera.y + self.yOffset - 4)
    self.hpBar:render(onScreenX, onScreenY) -- render the hp bar
    self:renderAggression(onScreenX, onScreenY) -- draw a little '!' if aggressive
end

-- search for a target entity, if found, play a sound and set aggressive speed boost
function Enemy:findTarget(entity)
    if GetDistance(self, entity) <= ENTITY_DEFS[self.name].aggressiveDistance * TILE_SIZE then -- if the entity is within the aggressive range
        gSounds['combat']['target_found']:play() -- play aggressive sound
        self.target = entity
        table.insert(self.boosts['speed'], {name = 'aggressive', multiplier = ENTITY_DEFS[self.name].aggressiveSpeedBoost})
    end 
end

-- release the current target, remove speed boost
function Enemy:loseTarget()
    self.target = nil -- target is now undefined
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
end

-- generates a list of items to drop from enemy's loot table, then spawns pickups accordingly
function Enemy:dropItems()
    print('try dropping items')
    local itemsToDrop = {} -- list of items to drop
    for i, item in pairs(ENTITY_DEFS[self.name].drops) do
        if math.random() < item.chance then -- go through each potential drop and check each one's chance against random number
            print('dropping item')
            table.insert(itemsToDrop, {name = item.name, x = self.x, y = self.y, quantity = math.random(item.min, item.max)})
        end
    end
    self.level.pickupManager:spawnPickups(itemsToDrop) -- create pickups with each of the dropped items
end

-- update all progress bars
function Enemy:updateBars()
    self.hpBar:updateRatio(self.currentStats.hp / self:getStat('maxHp')) -- update hp bar
end
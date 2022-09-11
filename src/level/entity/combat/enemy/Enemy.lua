--[[
    Enemy class: the enemies which the player will encounter in the world.
    attributes: name, target, agroDist, damage
    @author Saverton
]]

Enemy = Class{__includes = CombatEntity}

function Enemy:init(def, level, pos, startLevel, target)
    CombatEntity.init(self, def, level, pos)
    
    self.target = target or nil
    local agroBoostIndex = GetIndex(self.boosts.spd, 'agro')
    if agroBoostIndex ~= -1 then
        table.remove(self.boosts.spd, agroBoostIndex)
    end

    self.color = def.color or ENEMY_COLORS[math.min(#ENEMY_COLORS, self.statLevel.level)]

    self.hpBar = ProgressBar(self.x, self.y - 6, BAR_WIDTH, BAR_HEIGHT, {1, 0, 0, 1})

    self.statLevel:levelUpTo(startLevel or 0)
end

function Enemy:update(dt)
    CombatEntity.update(self, dt)

    if self.target == nil then
        -- try and find a target
        self:findTarget(self.level.player)
    else
        --check if damage target melee
        if Collide(self, self.target) then
            self.target:damage(self:getAttack(), ENTITY_DEFS[self.name].push, self, self.inflictions)
        end
        -- check if target is out of agro Range
        if GetDistance(self, self.target) > ENTITY_DEFS[self.name].agroDist * TILE_SIZE then
            self:loseTarget()
        end
    end
end

function Enemy:findTarget(entity)
    if GetDistance(self, entity) <= ENTITY_DEFS[self.name].agroDist * TILE_SIZE then
        gSounds['combat']['target_found']:play()
        self.target = entity
        table.insert(self.boosts.spd, {name = 'agro', num = ENTITY_DEFS[self.name].agroSpeedBoost})
    end 
end

function Enemy:loseTarget()
    self.target = nil
    table.remove(self.boosts.spd, GetIndex(self.boosts.spd, 'agro'))
end

function Enemy:render(camera)
    love.graphics.setColor(self.color)
    CombatEntity.render(self, camera) 

    local onScreenX = math.floor(self.x - camera.x + self.xOffset)
    local onScreenY = math.floor(self.y - camera.y + self.yOffset - 4)
    self.hpBar:render((self.currenthp / self:getHp()), onScreenX, onScreenY)
    if self.target ~= nil then
        love.graphics.setFont(gFonts['small'])
        love.graphics.setColor(1, 1, 0, 1)
        love.graphics.print('!', onScreenX - 3, onScreenY)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Enemy:dies()
    self.level:throwFlags{'kill enemy'}
    self:dropItems()
    self.level.player.statLevel:expGain(self.statLevel.level * ENTITY_DEFS[self.name].exp)
    CombatEntity.dies(self)
end

function Enemy:dropItems()
    local itemsToDrop = {}
    for i, item in pairs(ENTITY_DEFS[self.name].drops) do
        if math.random() < item.chance then
            table.insert(itemsToDrop, {name = item.name, x = self.x, y = self.y, quantity = math.random(item.min, item.max)})
        end
    end
    self.level.pickupManager:spawnPickups(itemsToDrop)
end
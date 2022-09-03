--[[
    Enemy class: the enemies which the player will encounter in the world.
    attributes: name, target, agroDist, damage
    @author Saverton
]]

Enemy = Class{__includes = Entity}

function Enemy:init(def, level, x, y, target)
    Entity.init(self, def, level, x, y)

    self.name = def.name
    self.target = target or nil
    self.agroDist = def.agroDist or 0 -- 0 = not aggressive

    self.color = def.color or ENEMY_COLORS[math.random(1, 8)]

    self.hpBar = ProgressBar(self.x, self.y - 6, BAR_WIDTH, BAR_HEIGHT, {1, 0, 0, 1})
end

function Enemy:update(dt)
    Entity.update(self, dt)

    if self.target == nil then
        -- process AI
        self:findTarget(self.level.player)
    else
        --check if damage target melee
        if Collide(self, self.target) then
            self.target:damage(self:getDamage(), ENTITY_DEFS[self.name].push, self, self.inflictions)
        end
        -- check if target is out of agro Range
        if GetDistance(self, self.target) > self.agroDist * TILE_SIZE then
            self:loseTarget()
        end
    end

    self.stateMachine:processAI()
end

function Enemy:findTarget(entity)
    if GetDistance(self, entity) <= self.agroDist * TILE_SIZE then
        self.target = entity
        table.insert(self.speedboost, {name = 'agro', num = ENTITY_DEFS[self.name].agroSpeedBoost})
    end 
end

function Enemy:loseTarget()
    self.target = nil
    table.remove(self.speedboost, GetIndex(self.speedboost, 'agro'))
end

function Enemy:render(camera)
    love.graphics.setColor(self.color)
    Entity.render(self, camera) 

    local onScreenX = math.floor(self.x - camera.x + self.xOffset)
    local onScreenY = math.floor(self.y - camera.y + self.yOffset - 4)
    self.hpBar:render((self.currenthp / self:getHp()), onScreenX, onScreenY)
end
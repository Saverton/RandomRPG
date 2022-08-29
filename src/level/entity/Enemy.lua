--[[
    Enemy class: the enemies which the player will encounter in the world.
    attributes: name, target, agroDist, damage
    @author Saverton
]]

Enemy = Class{__includes = Entity}

function Enemy:init(def, level, target, x, y)
    Entity.init(self, def, level, x, y)

    self.name = def.name
    self.target = target or nil
    self.agroDist = def.agroDist or 0 -- 0 = not aggressive

    self.attack = def.attack
    self.color = def.color or {math.random(), math.random(), math.random(), 1}
end

function Enemy:update(dt)
    Entity.update(self, dt)

    --[[
    if self.target == nil then
        -- process AI
        self:findTarget(self.level.player)
    else
        --check if damage target melee
        if Collide(self, self.target) then
            self.target:damage(self.attack)
        end
    end]]
end

function Enemy:findTarget(entity)
    if GetDistance(self, entity) <= self.agroDist then
        self.target = entity
    end
end

function Enemy:render(camera)
    love.graphics.setColor(self.color)
    Entity.render(self, camera) 
    love.graphics.setColor(1, 1, 1, 1)
end
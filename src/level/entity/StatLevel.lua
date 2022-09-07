--[[
    Stat Level class: determines the stats of a combat entity based on its level.
    @author Saverton
]]

StatLevel = Class{}

function StatLevel:init(entity, def)
    self.entity = entity
    self.level = 0

    -- bonus received on level up
    self.hpbonus = def.hpbonus or DEFAULT_BONUS
    self.attackbonus = def.attackbonus or DEFAULT_BONUS
    self.defensebonus = def.defensebonus or DEFAULT_BONUS
    self.magicbonus = def.magicbonus or DEFAULT_BONUS

    self:levelUp(def.level or 1)
    self.exp = def.exp or math.pow(3, self.level - 1)
end

function StatLevel:expGain(amount)
    self.exp = self.exp + amount
    if self.exp >= math.pow(3, self.level) then
        self:levelUp(1)
        return true
    end
    return false
end

function StatLevel:levelUp(amount)
    for i = 1, amount, 1 do
        self.level = self.level + 1
        local hpnum = math.random()
        local atknum = math.random()
        local defnum = math.random()
        local magicnum = math.random()
        if hpnum < self.hpbonus.chance then
            self.entity.hp = self.entity.hp + self.hpbonus.bonus
        end
        if atknum < self.attackbonus.chance then
            self.entity.attack = self.entity.attack + self.attackbonus.bonus
        end
        if defnum < self.defensebonus.chance then
            self.entity.defense = self.entity.defense + self.defensebonus.bonus
        end
        if magicnum < self.magicbonus.chance then
            self.entity.magic = self.entity.magic + self.magicbonus.bonus
        end
        self.entity.currenthp = self.entity:getHp()
    end
end

function StatLevel:getExpRatio()
    return ((self.exp - math.pow(3, self.level - 1)) / (math.pow(3, self.level)))
end
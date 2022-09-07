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
        local oldStats = {
            hp = 'HP: ' .. tostring(self.entity.hp),
            atk = 'ATK: ' .. tostring(self.entity.attack),
            def = 'DEF: ' .. tostring(self.entity.defense),
            magic = 'MAGIC: ' .. tostring(self.entity.magic)
        }
        local bonuses = self:levelUp(1)
        local newStats = {
            hp = self.entity.hp,
            atk = self.entity.attack,
            def = self.entity.defense,
            magic = self.entity.magic
        }
        local selections = {
            Selection(oldStats.hp .. ' + ' .. tostring(bonuses.hp) .. ' = ' .. tostring(newStats.hp)),
            Selection(oldStats.atk .. ' + ' .. tostring(bonuses.atk) .. ' = ' .. tostring(newStats.atk)),
            Selection(oldStats.def .. ' + ' .. tostring(bonuses.def) .. ' = ' .. tostring(newStats.def)),
            Selection(oldStats.magic .. ' + ' .. tostring(bonuses.magic) .. ' = ' .. tostring(newStats.magic))
        }
        gStateStack:push(MenuState(MENU_DEFS['level_up'], {selections = selections}))
        return true
    end
    return false
end

function StatLevel:levelUp(amount)
    local bonuses = {
        hp = 0,
        atk = 0,
        def = 0,
        magic = 0
    }
    for i = 1, amount, 1 do
        self.level = self.level + 1
        local hpnum = math.random()
        local atknum = math.random()
        local defnum = math.random()
        local magicnum = math.random()
        if hpnum < self.hpbonus.chance then
            self.entity.hp = self.entity.hp + self.hpbonus.bonus
            bonuses.hp = self.hpbonus.bonus
        end
        if atknum < self.attackbonus.chance then
            self.entity.attack = self.entity.attack + self.attackbonus.bonus
            bonuses.atk = self.attackbonus.bonus
        end
        if defnum < self.defensebonus.chance then
            self.entity.defense = self.entity.defense + self.defensebonus.bonus
            bonuses.def = self.defensebonus.bonus
        end
        if magicnum < self.magicbonus.chance then
            self.entity.magic = self.entity.magic + self.magicbonus.bonus
            bonuses.magic = self.magicbonus.bonus
        end
        self.entity.currenthp = self.entity:getHp()
    end
    return bonuses
end

function StatLevel:getExpRatio()
    return ((self.exp - math.pow(3, self.level - 1)) / (math.pow(3, self.level) - math.pow(3, self.level - 1)))
end
--[[
    Stat Level class: leveling system for combat entities, keeps track of the entity's level, exp amount, and the bonuses received upon leveling
    up.
    @author Saverton
]]

StatLevel = Class{}

function StatLevel:init(entity, definitions)
    self.entity = entity -- reference to owner entity
    self.level = (definitions or {}).level or 1 -- starting level
    self.bonuses  = (definitions or {}).bonuses or {
        ['maxHp'] = DEFAULT_BONUS,
        ['attack'] = DEFAULT_BONUS,
        ['defense'] = DEFAULT_BONUS,
        ['maxMana'] = 0
    } -- potential bonuses for each level up
    self.exp = (definitions or {}).exp or math.pow(3, self.level - 1) -- starting exp
end

-- give the stat level expereince
function StatLevel:expGain(amount)
    self.exp = self.exp + amount -- add new exp
    if self.exp >= math.pow(3, self.level) then
        self:playerLevelUp() -- if this is enough to level up, call the player level up function
        return true
    end
    self.entity.expBar:updateRatio(self:getExpRatio())
    return false
end

-- level up an enemy, auto upgrades each bonus accordingly
function StatLevel:enemyLevelUp(amount)
    for i = 1, amount, 1 do
        self.level = self.level + 1 -- add one level
        self:upgradeStat('maxHp')
        self:upgradeStat('attack')
        self:upgradeStat('defense')
        self:upgradeStat('maxMana')
        self.entity.currentStats.hp = self.entity:getStat('maxHp') -- add all bonuses and set current hp to the new max hp
        self.entity.hpBar:updateRatio(self.entity.currentStats.hp / self.entity:getStat('maxHp')) -- update the health bar
    end
end

-- level up a player, allows choice of stat upgrades
function StatLevel:playerLevelUp()
    gSounds['gui']['level_up']:play() -- play level up sound
    self.level = self.level + 1
    local selections = {
        Selection('HP + ' .. self.bonuses['maxHp'], function() 
            self:upgradeStat('maxHp') 
            self.entity:totalHeal() -- bring player back to full health
            gStateStack:pop()
        end),
        Selection('Attack + ' .. self.bonuses['attack'], function() 
            self:upgradeStat('attack')
            gStateStack:pop()
        end),
        Selection('Defense + ' .. self.bonuses['defense'], function() 
            self:upgradeStat('defense') 
            gStateStack:pop()
        end),
        Selection('Mana + ' .. self.bonuses['maxMana'], function() 
            self:upgradeStat('maxMana') 
            gStateStack:pop()
        end),
    }
    gStateStack:push(MenuState(MENU_DEFS['level_up'], {selections = selections}))
    self.entity:updateBars() -- update stat bars
end

-- level up an enemy to a certain level, used when initiating an enemy to a level higher than 1
function StatLevel:levelUpTo(level)
    return self:enemyLevelUp(math.max(0, level - self.level))
end

-- upgrade a specific stat
function StatLevel:upgradeStat(statName)
    self.entity.combatStats[statName] = self.entity.combatStats[statName] + self.bonuses[statName]
    self.entity:updateBars()
end

-- get the ratio of current exp to the exp needed for the next level
function StatLevel:getExpRatio()
    return ((self.exp - math.pow(3, self.level - 1)) / (math.pow(3, self.level) - math.pow(3, self.level - 1)))
end

-- return a table with the necessary save data
function StatLevel:getSaveData()
    return {
        level = self.level,
        exp = self.exp,
        bonuses = self.bonuses
    }
end
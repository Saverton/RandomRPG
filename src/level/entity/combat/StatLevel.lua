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
    local didLevelUp = false
    self.exp = self.exp + amount -- add new exp
    didLevelUp = self:checkForLevelUp()
    self.entity.expBar:updateRatio(self:getExpRatio())
    return didLevelUp
end

-- level up an enemy, auto upgrades each bonus accordingly
function StatLevel:enemyLevelUp(amount)
    for _ = 1, amount, 1 do
        self.level = self.level + 1 -- add one level

        -- upgrade a random stat
        local stats = {
            'maxHp',
            'attack',
            'defense'
        }
        self:upgradeStat(stats[math.random(3)])

        -- add all bonuses and set current hp to the new max hp
        self.entity.currentStats.hp = self.entity:getStat('maxHp')
        self.entity.hpBar:updateRatio(self.entity.currentStats.hp / self.entity:getStat('maxHp'))
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
    self.entity:updateStatBars() -- update stat bars
    self:checkForLevelUp() -- check if the player needs to level up again in case enough exp was gained to pass the threshold again.
end

-- level up an enemy to a certain level, used when initiating an enemy to a level higher than 1
function StatLevel:levelUpTo(level)
    return self:enemyLevelUp(math.max(0, level - self.level))
end

-- upgrade a specific stat
function StatLevel:upgradeStat(statName)
    self.entity.combatStats[statName] = self.entity.combatStats[statName] + self.bonuses[statName]
    self.entity:updateStatBars()
end

-- get the ratio of current exp to the exp needed for the next level
function StatLevel:getExpRatio()
    local expToNextLvl = self.getExpToLevel(self.level + 1)
    local expToLastLvl = self.getExpToLevel(self.level)

    return (self.exp - expToLastLvl) / (expToNextLvl - expToLastLvl)
end

-- return a table with the necessary save data
function StatLevel:getSaveData()
    return {
        level = self.level,
        exp = self.exp,
        bonuses = self.bonuses
    }
end

function StatLevel.getExpToLevel(level)
    assert(type(level) == 'number', 'level must be a number')
    return math.pow(3, level - 1)
end

-- check if the exp bar is full and, if so, level up
function StatLevel:checkForLevelUp()
    if self.exp >= self.getExpToLevel(self.level + 1) then
        self:playerLevelUp()
        return true
    else
        return false
    end
end

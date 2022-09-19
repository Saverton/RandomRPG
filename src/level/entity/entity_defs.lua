--[[
    Table defining attributes for all entities.
    @author Saverton
]]

ENEMY_COLORS = {
    [1] = {91/255, 176/255, 113/255, 1},
    [2] = {150/255, 250/255, 142/255, 1},
    [3] = {212/255, 172/255, 72/255, 1},
    [4] = {125/255, 93/255, 84/255, 1},
    [5] = {150/255, 83/255, 117/255, 1},
    [6] = {208/255, 99/255, 214/255, 1},
    [7] = {128/255, 125/255, 199/255, 1},
    [8] = {49/255, 47/255, 94/255, 1},
    [9] = {138/255, 138/255, 138/255, 1},
    [10] = {102/255, 8/255, 8/255, 1},
    [11] = {222/255, 38/255, 38/255, 1}
}

ENTITY_DEFS = {
    ['player'] = {
        name = 'player',
        displayName = 'Player',
        width = PLAYER_WIDTH,
        height = PLAYER_HEIGHT,
        xOffset = PLAYER_X_OFFSET,
        yOffset = PLAYER_Y_OFFSET,
        combatStats = {
            ['maxHp'] = PLAYER_BASE_HP,
            ['attack'] = PLAYER_BASE_ATTACK,
            ['defense'] = PLAYER_BASE_DEFENSE,
            ['maxMana'] = PLAYER_BASE_MANA
        },
        speed = PLAYER_BASE_SPEED,
        manaRegenRate = 0.5,
        push = 16,
        deathSound = 'player_dies',
        statLevel = {
            bonuses = {
                ['maxHp'] = 1,
                ['attack'] = 1,
                ['defense'] = 1,
                ['maxMana'] = 1
            }
        }
    },
    ['goblin'] = {
        name = 'goblin',
        displayName = 'Goblin',
        width = 12,
        height = 12,
        xOffset = -2,
        yOffset = -4,
        combatStats = {
            ['maxHp'] = 3,
            ['attack'] = 1,
            ['defense'] = 1,
            ['maxMana'] = 0
        },
        speed = 16,
        aggressiveSpeedBoost = 2,
        aggressiveDistance = 7,
        exp = 1,
        drops = {{name = 'ammo', chance = 0.5, min = 1, max = 3},
            {name = 'health', chance = 0.25, min = 1, max = 1},
            {name = 'money', chance = 0.75, min = 1, max = 3}},
        deathSound = 'enemy_dies',
        push = 8
    },
    ['skeleton'] = {
        name = 'skeleton',
        displayName = 'Skeleton',
        width = 12,
        height = 12,
        xOffset = -2,
        yOffset = -4,
        combatStats = {
            ['maxHp'] = 5,
            ['attack'] = 1,
            ['defense'] = 1,
            ['maxMana'] = 0
        },
        speed = 16,
        aggressiveSpeedBoost = 2,
        aggressiveDistance = 7,
        exp = 3,
        drops = {{name = 'ammo', chance = 0.5, min = 2, max = 5},
            {name = 'health', chance = 0.25, min = 1, max = 1},
            {name = 'money', chance = 1, min = 2, max = 4}},
        deathSound = 'enemy_dies',
        push = 8,
        items = {
            {name = 'wooden_sword', quantity = 1}
        }
    },
    ['wizard'] = {
        name = 'wizard',
        displayName = 'Wizard',
        width = 12,
        height = 12,
        xOffset = -2,
        yOffset = -4,
        combatStats = {
            ['maxHp'] = 10,
            ['attack'] = 2,
            ['defense'] = 1,
            ['maxMana'] = 3
        },
        speed = 16,
        aggressiveSpeedBoost = 2,
        aggressiveDistance = 9,
        exp = 10,
        manaRegenRate = 1,
        drops = {{name = 'health', chance = 1, min = 1, max = 1},
            {name = 'money', chance = 1, min = 5, max = 10},
            {name = 'hp_upgrade', chance = 1, min = 1, max = 1},
            {name = 'key', chance = 1, min = 1, max = 1}
        },
        deathSound = 'enemy_dies',
        push = 8,
        items = {
            {name = 'fire_tome', quantity = 1}
        }
    }
}

NPC_DEFS = {
    ['tips'] = {
        name = 'tips',
        animationName = 'npc',
        displayName = 'Advisor',
        width = 16,
        height = 16,
        startAnim = 'idle-down',
        onInteract = function(player, npc)
            gStateStack:push(
                DialogueState(TIPS[math.random(#TIPS)], npc.animator.texture, 1)
            )
        end,
        isDespawnable = function(npc)
            return (npc.timesInteractedWith >= 1)
        end,
        speed = 16,
    },
    ['shop'] = {
        name = 'shop',
        animationName = 'npc',
        displayName = 'Shopkeeper',
        width = 16,
        height = 16,
        startAnim = 'idle-down',
        hasShop = true,
        shop = {
            size = 3,
            itemPool = {'ammo', 'health', 'sword', 'bow', 'key'}
        },
        onInteract = function(player, npc)
            npc.shop:open(player)
        end,
        isDespawnable = function(npc)
            return (npc.shop:getNumberOfItems() == 0 or npc.timesInteractedWith >= 5)
        end,
        speed = 16,
    },
    ['quest'] = {
        name = 'quest',
        animationName = 'npc',
        displayName = 'Questgiver',
        width = 16,
        height = 16,
        startAnim = 'idle-down',
        hasQuest = true,
        onInteract = function(player, npc)
            npc.quest:check(player)
        end,
        isDespawnable = function(npc)
            return (npc.quest.completed or npc.quest.denied)
        end,
        speed = 16,
    }
}
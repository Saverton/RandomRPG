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
        hp = PLAYER_BASE_HP,
        attack = PLAYER_BASE_ATTACK,
        speed = PLAYER_BASE_SPEED,
        defense = PLAYER_BASE_DEFENSE,
        magic = PLAYER_BASE_MAGIC,
        magicRegenRate = 0.5,
        onDeath = function() love.audio.play(gSounds['player_dies_1']) end,
        push = 16,
        statLevel = {
            hpbonus = {chance = 0.5, bonus = 1},
            atkbonus = {chance = 0.5, bonus = 1},
            defbonus = {chance = 0.25, bonus = 1},
            magicbonus = {chance = 0.25, bonus = 1}
        }
    },
    ['goblin'] = {
        name = 'goblin',
        displayName = 'Goblin',
        width = 12,
        height = 12,
        xOffset = -2,
        yOffset = -4,
        hp = 5,
        speed = 16,
        agroSpeedBoost = 2,
        defense = 1,
        attack = 1,
        agroDist = 7,
        exp = 1,
        onDeath = function(entity, level) 
            love.audio.play(gSounds['enemy_dies_1'])
            if math.random(1, 3) == 1 then
                table.insert(level.pickupManager.pickups, Pickup('ammo', entity.x + math.random(entity.width) - 8, entity.y + math.random(entity.height) - 8, math.random(2, 5)))
            end
            if math.random(1, 3) ~= 1 then
                table.insert(level.pickupManager.pickups, Pickup('money', entity.x + math.random(entity.width) - 8, entity.y + math.random(entity.height), math.random(1, 2)))
            end
            if math.random(1, 5) == 1 then
                table.insert(level.pickupManager.pickups, Pickup('health', entity.x + math.random(entity.width) - 8, entity.y + math.random(entity.height) - 8, 1))
            end
        end,
        push = 8
    },
    ['skeleton'] = {
        name = 'skeleton',
        displayName = 'Skeleton',
        width = 12,
        height = 12,
        xOffset = -2,
        yOffset = -4,
        hp = 5,
        speed = 16,
        agroSpeedBoost = 2,
        defense = 1,
        attack = 1,
        agroDist = 7,
        exp = 3,
        onDeath = function(entity, level) 
            love.audio.play(gSounds['enemy_dies_1'])
            if math.random(1, 3) == 1 then
                table.insert(level.pickupManager.pickups, Pickup('ammo', entity.x + math.random(entity.width) - 8, entity.y + math.random(entity.height) - 8, math.random(2, 5)))
            end
            if math.random(1, 3) ~= 1 then
                table.insert(level.pickupManager.pickups, Pickup('money', entity.x + math.random(entity.width) - 8, entity.y + math.random(entity.height), math.random(1, 2)))
            end
            if math.random(1, 5) == 1 then
                table.insert(level.pickupManager.pickups, Pickup('health', entity.x + math.random(entity.width) - 8, entity.y + math.random(entity.height) - 8, 1))
            end
        end,
        push = 8,
        items = {
            {name = 'sword', quantity = 1}
        }
    }
}

NPC_DEFS = {
    ['tips'] = {
        name = 'tips',
        animName = 'npc',
        displayName = 'Test NPC',
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
        animName = 'npc',
        displayName = 'Shop NPC',
        width = 16,
        height = 16,
        startAnim = 'idle-down',
        hasShop = true,
        shop = {
            size = 3,
            itemPool = {'ammo', 'health', 'sword', 'bow', 'battle_axe', 'hp_upgrade'}
        },
        onInteract = function(player, npc)
            npc.shop:open(player)
        end,
        isDespawnable = function(npc)
            return (npc.shop:getNumItems() == 0)
        end,
        speed = 16,
    },
    ['quest'] = {
        name = 'quest',
        animName = 'npc',
        displayName = 'Quest NPC',
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
--[[
    Definitions for all items in the game.
    @author Saverton
]]

ITEM_DEFS = {
    ['sword'] = {
        name = 'sword',
        displayName = 'Sword',
        description = 'A basic sword, swipes outward and can strike multiple enemies.',
        type = 'melee',
        stackable = false,
        texture = 'items',
        frame = 1,
        price = {
            buy = 10,
            sell = 5
        },
        useRate = 0.4,
        useTime = 0.3,
        useRange = 2,
        useSound = 'sword_swing_1',
        pickupSound = 'special_item',
        onUse = function(item, holder, target)
            holder:changeState('interact', {time = ITEM_DEFS[item.name].useTime})
            local origin = {x = holder.x, y = holder.y, direction = holder.direction}

            holder.projectileManager:spawnProjectile('sword', origin)
        end
    },
    ['bow'] = {
        name = 'bow',
        displayName = 'Bow',
        description = 'Shoots arrows in the direction you aim, requires ammo to use.',
        type = 'ranged',
        stackable = false,
        cost = 1,
        texture = 'items',
        frame = 2,
        price = {
            buy = 15,
            sell = 8
        },
        useRate = 0.5,
        useTime = 0.3,
        useRange = 9,
        useSound = 'bow_shot',
        pickupSound = 'special_item',
        onUse = function(item, holder, target)
            holder:changeState('interact', {time = ITEM_DEFS[item.name].useTime})
            local origin = {x = holder.x, y = holder.y, direction = holder.direction}

            holder.projectileManager:spawnProjectile('bow', origin)
            holder.projectileManager:spawnProjectile('arrow', origin)
        end
    },
    ['fire_tome'] = {
        name = 'fire_tome',
        displayName = 'Tome of Fire',
        description = 'This magic tome summons a fireball that can set enemies on fire for a couple seconds, requires mana to use',
        type = 'magic',
        stackable = false,
        cost = 2,
        texture = 'items',
        frame = 3,
        price = {
            buy = 20,
            sell = 10
        },
        useRate = 1,
        useTime = 0.5,
        useRange = 5,
        useSound = 'use_magic',
        pickupSound = 'special_item',
        onUse = function(item, holder, target)
            holder:changeState('interact', {time = ITEM_DEFS[item.name].useTime})
            local origin = {x = holder.x, y = holder.y, direction = holder.direction}

            holder.projectileManager:spawnProjectile('tome', origin)
            holder.projectileManager:spawnProjectile('fireball', origin)
        end
    },
    ['ammo'] = {
        name = 'ammo',
        displayName = 'Ammo',
        description = 'Ammunition for ranged weapons.',
        type = 'item',
        stackable = true,
        texture = 'projectiles',
        frame = 8,
        price = {
            buy = 1,
            sell = 0
        },
        useRate = 0,
        useTime = 0,
        onUse = function() end
    },
    ['health'] = {
        name = 'health',
        displayName = 'Health',
        description = 'A Health pickup that restores the player\'s life.',
        type = 'pickup',
        stackable = true,
        texture = 'items',
        frame = 4,
        price = {
            buy = 5,
            sell = 0
        },
        useRate = 0,
        useTime = 0,
        onUse = function() end,
        onPickup = function(holder, quantity) holder:heal(quantity) end
    },
    ['money'] = {
        name = 'money',
        displayName = 'Money',
        description = 'The currency of this world.',
        type = 'pickup',
        stackable = true,
        texture = 'items',
        frame = 5,
        price = {
            buy = 1,
            sell = 1
        },
        useRate = 0,
        useTime = 0,
        pickupSound = 'money',
        onUse = function() end,
        onPickup = function(holder, quantity) holder.money = holder.money + quantity end
    },
    ['ice_tome'] = {
        name = 'ice',
        displayName = 'Tome of Ice',
        description = 'This magic tome summons an Ice beam that can slow down enemies for a couple seconds, requires mana to use',
        type = 'magic',
        stackable = false,
        cost = 1,
        texture = 'items',
        frame = 6,
        price = {
            buy = 20,
            sell = 10
        },
        useRate = 1,
        useTime = 0.5,
        useRange = 5,
        useSound = 'use_magic',
        pickupSound = 'special_item',
        onUse = function(item, holder, target)
            holder:changeState('interact', {time = ITEM_DEFS[item.name].useTime})
            local origin = {x = holder.x, y = holder.y, direction = holder.direction}

            holder.projectileManager:spawnProjectile('tome', origin)
            holder.projectileManager:spawnProjectile('ice', origin)
        end
    },
    ['wooden_sword'] = {
        name = 'wooden_sword',
        displayName = 'Wooden Sword',
        description = 'A basic and weak sword, swipes outward and can strike multiple enemies.',
        type = 'melee',
        stackable = false,
        texture = 'items',
        frame = 7,
        price = {
            buy = 5,
            sell = 1
        },
        useRate = 0.4,
        useTime = 0.3,
        useRange = 2,
        useSound = 'sword_swing_1',
        onUse = function(item, holder, target)
            holder:changeState('interact', {time = ITEM_DEFS[item.name].useTime})
            local origin = {x = holder.x, y = holder.y, direction = holder.direction}
            holder.projectileManager:spawnProjectile('wooden_sword', origin)
        end
    },
    ['battle_axe'] = {
        name = 'battle_axe',
        displayName = 'Battle Axe',
        description = 'A strong melee weapon. Swipes outward, like a sword, but slower. Can be used to remove trees.',
        type = 'melee',
        stackable = false,
        texture = 'items',
        frame = 8,
        price = {
            buy = 30,
            sell = 15
        },
        useRate = 1.5,
        useTime = 0.5,
        useRange = 2,
        useSound = 'battle_axe',
        pickupSound = 'special_item',
        onUse = function(item, holder, target)
            holder:changeState('interact', {time = ITEM_DEFS[item.name].useTime})
            local origin = {x = holder.x, y = holder.y, direction = holder.direction}

            holder.projectileManager:spawnProjectile('battle_axe', origin)
        end
    },
    ['wood'] = {
        name = 'wood',
        displayName = 'Wood',
        description = 'Wood can be used to make bridges.',
        type = 'item',
        stackable = true,
        texture = 'items',
        frame = 10,
        price = {
            buy = 1,
            sell = 0
        },
        useRate = 0,
        useTime = 0,
        onUse = function() end
    },
    ['hp_upgrade'] = {
        name = 'hp_upgrade',
        displayName = 'Health Upgrade',
        description = 'A Health pickup that increases the player\'s maximum health.',
        type = 'pickup',
        stackable = false,
        texture = 'items',
        frame = 9,
        price = {
            buy = 30,
            sell = 0
        },
        useRate = 0,
        useTime = 0,
        onUse = function() end,
        onPickup = function(holder, quantity) 
            holder.combatStats['maxHp'] = holder.combatStats['maxHp'] + 1 
            holder:totalHeal() -- totally heal the entity
        end
    },
    ['key'] = {
        name = 'key',
        displayName = 'Key',
        description = 'Can open locked doors',
        type = 'item',
        stackable = true,
        texture = 'items',
        frame = 11,
        price = {
            buy = 15,
            sell = 1
        },
        useRate = 0.5,
        useTime = 0.5,
        onUse = function(item, holder, target) 
            holder:changeState('interact', {time = ITEM_DEFS[item.name].useTime})
            local origin = {x = holder.x, y = holder.y, direction = holder.direction}

            holder.projectileManager:spawnProjectile('key', origin)
        end,
        onPickup = function() end
    }
}
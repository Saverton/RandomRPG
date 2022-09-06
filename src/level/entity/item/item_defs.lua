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
        onUse = function(item, holder, target)
            love.audio.play(gSounds['sword_swing_1'])
            holder:changeState('interact', {time = ITEM_DEFS[item.name].useTime})
            local pos = GetStartPosition(holder)

            table.insert(holder.projectiles, Projectile('sword', pos))
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
        onUse = function(item, holder, target)
            love.audio.play(gSounds['hit_1'])
            holder:changeState('interact', {time = ITEM_DEFS[item.name].useTime})
            local pos = GetStartPosition(holder)

            table.insert(holder.projectiles, Projectile('bow', pos))
            table.insert(holder.projectiles, Projectile('arrow', pos))
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
        onUse = function(item, holder, target)
            love.audio.play(gSounds['fire_hit_1'])
            holder:changeState('interact', {time = ITEM_DEFS[item.name].useTime})
            local pos = GetStartPosition(holder)

            table.insert(holder.projectiles, Projectile('tome', pos))
            table.insert(holder.projectiles, Projectile('firebal', pos))
        end
    },
    ['ammo'] = {
        name = 'ammo',
        displayName = 'Ammo',
        description = 'Ammunition for ranged weapons.',
        type = 'pickup',
        stackable = true,
        texture = 'projectiles',
        frame = 8,
        price = {
            buy = 1,
            sell = 0
        },
        useRate = 0,
        useTime = 0,
        onUse = function() end,
        onPickup = function(holder, quantity) holder.ammo = holder.ammo + quantity end
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
        onUse = function(item, holder, target)
            love.audio.play(gSounds['hit_1'])
            holder:changeState('interact', {time = ITEM_DEFS[item.name].useTime})
            local pos = GetStartPosition(holder)

            table.insert(holder.projectiles, Projectile('tome', pos))
            table.insert(holder.projectiles, Projectile('ice', pos))
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
        onUse = function(item, holder, target)
            love.audio.play(gSounds['sword_swing_1'])
            holder:changeState('interact', {time = ITEM_DEFS[item.name].useTime})
            local pos = GetStartPosition(holder)

            table.insert(holder.projectiles, Projectile('wooden_sword', pos))
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
        onUse = function(item, holder, target)
            love.audio.play(gSounds['sword_swing_1'])
            holder:changeState('interact', {time = ITEM_DEFS[item.name].useTime})
            local pos = GetStartPosition(holder)

            table.insert(holder.projectiles, Projectile('battle_axe', pos))
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
        frame = 4,
        price = {
            buy = 30,
            sell = 0
        },
        useRate = 0,
        useTime = 0,
        onUse = function() end,
        onPickup = function(holder, quantity) 
            holder.hp = holder.hp + 1 
            holder.currenthp = holder.currenthp + 1
        end
    }
}
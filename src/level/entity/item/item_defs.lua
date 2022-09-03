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

            table.insert(holder.projectiles, Projectile('sword', {
                x = pos.x,
                y = pos.y
            }, pos.dx, pos.dy, DIRECTION_TO_NUM[holder.direction]))
        end
    },
    ['bow'] = {
        name = 'bow',
        displayName = 'Bow',
        description = 'Shoots arrows in the direction you aim, requires ammo to use.',
        type = 'ranged',
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

            table.insert(holder.projectiles, Projectile('bow', {
                x = pos.x,
                y = pos.y
            }, pos.dx, pos.dy, DIRECTION_TO_NUM[holder.direction]))
            table.insert(holder.projectiles, Projectile('arrow', {
                x = pos.x,
                y = pos.y
            }, pos.dx, pos.dy, DIRECTION_TO_NUM[holder.direction]))
        end
    },
    ['fire_tome'] = {
        name = 'fire_tome',
        displayName = 'Tome of Fire',
        description = 'This magic tome summons a fireball that can set enemies on fire for a couple seconds, requires mana to use',
        type = 'magic',
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

            table.insert(holder.projectiles, Projectile('tome', {x = pos.x, y = pos.y}, pos.dx, pos.dy, DIRECTION_TO_NUM[holder.direction]))
            table.insert(holder.projectiles, Projectile('fireball', {x = pos.x, y = pos.y}, pos.dx, pos.dy, DIRECTION_TO_NUM[holder.direction]))
        end
    },
    ['ammo'] = {
        name = 'ammo',
        type = 'pickup',
        texture = 'arrow',
        frame = 1,
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
        type = 'pickup',
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
        type = 'pickup',
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
    }
}
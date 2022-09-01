--[[
    Definitions for all items in the game.
    @author Saverton
]]

ITEM_DEFS = {
    ['sword'] = {
        name = 'sword',
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
        type = 'magic',
        cost = 1,
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
    }
}
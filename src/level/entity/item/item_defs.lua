--[[
    Definitions for all items in the game.
    @author Saverton
]]

ITEM_DEFS = {
    ['sword'] = {
        name = 'sword',
        weapon = true,
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
        weapon = true,
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
    }
}
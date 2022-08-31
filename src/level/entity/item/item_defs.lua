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
        useRate = 0.3,
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
    }
}
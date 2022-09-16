--[[
    Definitions for all status effects in the game.
    @author Saverton
]]

EFFECT_DEFS = {
    ['burn'] = {
        texture = 'effects',
        frame = 1,
        onApply = function() end,
        applyEvery = function(holder) 
            holder:hurt(1) -- lose 1hp
            love.audio.play(gSounds['combat']['fire_hit_1']) -- play burn sound
        end,
        afterEffect = function() end,
        applied_every = 1
    },
    ['freeze'] = {
        texture = 'effects',
        frame = 2,
        onApply = function(holder)
            table.insert(holder.boosts['speed'], {name = 'freeze', multiplier = 0.25}) -- slow move speed
        end,
        applyEvery = function() end,
        afterEffect = function(holder)
            table.remove(holder.boosts['speed'], GetIndex(holder.boosts['speed'], 'freeze')) -- remove freeze effect
        end,
        applied_every = 100
    }
}

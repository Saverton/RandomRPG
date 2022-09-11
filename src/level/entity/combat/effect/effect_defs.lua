--[[
    Definitions for all status effects in the game.
    @author Saverton
]]

EFFECT_DEFS = {
    ['burn'] = {
        texture = 'effects',
        frame = 1,
        effect = function(holder) 
            --every second lose 1hp
            holder:hurt(1)
            --play burn sound
            love.audio.play(gSounds['combat']['fire_hit_1'])
        end,
        applied_every = 1,
        render = function(holder, texture, frame, camera) 
            for i = 1, 2, 1 do
                love.graphics.draw(gTextures[texture], gFrames[texture][frame], math.floor((holder.x - 4) + (math.random(0, holder.width))) - camera.x, 
                    math.floor((holder.y - 4) + (math.random(0, holder.height))) - camera.y)
            end
        end,
        afterEffect = function() end
    },
    ['freeze'] = {
        texture = 'effects',
        frame = 2,
        effect = function(holder)
            --once slow move speed
            table.insert(holder.boosts.spd, {name = 'freeze', num = 0.25})
        end,
        applied_every = 100,
        render = function(holder, texture, frame, camera) 
            for i = 1, 2, 1 do
                love.graphics.draw(gTextures[texture], gFrames[texture][frame], math.floor((holder.x - 4) + (math.random(0, holder.width))) - camera.x, 
                    math.floor((holder.y - 4) + (math.random(0, holder.height))) - camera.y)
            end
        end,
        afterEffect = function(holder)
            table.remove(holder.boosts.spd, GetIndex(holder.speedboost, 'freeze'))
        end
    }
}

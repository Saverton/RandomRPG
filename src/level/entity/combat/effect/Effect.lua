--[[
    Effect class: effects that can impact entity stats in combat. Has functions that are called on apply, every x seconds, and after effect ends.
    @author Saverton
]]

Effect = Class{}

function Effect:init(name, duration, holder)
    self.name = name -- effect's name
    self.duration = duration -- duration of the effect (in seconds)
    self.holder = holder -- reference to the effect's holder/owner
    self.secondCounter = 0 -- counts seconds for the purpose of the apply-every function
    EFFECT_DEFS[self.name].onApply(self.holder) -- apply once when effect is gained
end

-- update the effect
function Effect:update(dt)
    self.duration = math.max(0, self.duration - dt)
    self.secondCounter = self.secondCounter + dt -- update timers
    if self.secondCounter >= EFFECT_DEFS[self.name].applied_every then
        self.secondCounter = 0
        EFFECT_DEFS[self.name].applyEvery(self.holder) -- call apply every function
    end
    if self.duration <= 0 then
        EFFECT_DEFS[self.name].afterEffect(self.holder) -- call after effect function
    end
end

-- render the effect on the entity
function Effect:render(camera)
    local texture, frame = EFFECT_DEFS[self.name].texture, EFFECT_DEFS[self.name].frame -- get the texture and frame for this effect
    for i = 1, 2, 1 do -- draw two of the effect particles at random spots.
        local x, y = math.floor((self.holder.x - 4) + (math.random(0, self.holder.width))) - camera.x, 
            math.floor((self.holder.y - 4) + (math.random(0, self.holder.height))) - camera.y -- get a random x, y position on the holder
        love.graphics.draw(gTextures[texture], gFrames[texture][frame], x, y) -- draw the particle
    end
end
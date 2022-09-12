--[[
    Effect class: effects that can impact entities in combat.
    attributes: name, duration(seconds), holder, effect(), render(), afterEffect()
    @author Saverton
]]

Effect = Class{}

function Effect:init(name, duration, holder)
    self.name = name
    self.duration = duration
    self.holder = holder
    self.count = 0

    -- apply once when effect is gained
    EFFECT_DEFS[self.name].effect(self.holder)
end

function Effect:update(dt)
    self.duration = math.max(0, self.duration - dt)
    self.count = self.count + dt

    if self.count >= EFFECT_DEFS[self.name].applied_every then
        self.count = 0
        EFFECT_DEFS[self.name].effect(self.holder)
    end

    if self.duration <= 0 then
        EFFECT_DEFS[self.name].afterEffect(self.holder)
    end
end

function Effect:render(camera)
    return EFFECT_DEFS[self.name].render(self.holder, EFFECT_DEFS[self.name].texture, EFFECT_DEFS[self.name].frame, camera)
end
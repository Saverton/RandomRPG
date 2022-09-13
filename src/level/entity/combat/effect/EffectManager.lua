--[[
    Effect Manager: manages all status effects for combat entities. Applies any held effects when initiated.
    @author Saverton
]]

EffectManager = Class{}

function EffectManager:init(entity, definitions)
    self.entity = entity -- reference to owner of this effect manager
    self.effects = definitions.effects or {} -- currently held effects
    self.immunities = definitions.immunities or {} -- effects to which this is immune to
    self.inflictions = definitions.inflictions or {} -- effects which this inflicts on others
end

-- update all effects and remove completed ones
function EffectManager:update(dt)
    local effectsToRemove = {} -- effects to remove at the end of this update cycle
    for i, effect in ipairs(self.effects) do
        effect:update(dt)
        if effect.duration == 0 then
            table.insert(effectsToRemove, i) -- mark this effect to be removed
        end
    end
    for i, index in ipairs(effectsToRemove) do
        table.remove(self.effects, index) -- remove the effects at the marked indexes
    end
end

-- render all of the effects at a given x and y
function EffectManager:render(x, y)
    for i, effect in ipairs(self.effects) do
        effect:render(x, y)
    end
end

-- inflict a list of effects on this entity
function EffectManager:inflict(effectsToInflict)
    for i, effect in pairs(effectsToInflict) do
        if not Contains(self.immunities, effect.name) then -- if this entity is immune, don't inflict
            if not ContainsName(self.effects, effect.name) then -- if this entity already has this effect, just reset duration
                table.insert(self.effects, Effect(effect.name, effect.duration, self)) -- add new effect
            else
                self.effects[GetIndex(self.effects, effect.name)].duration = effect.duration --reset duration
            end
        end
    end
end

-- return a table of save data
function EffectManager:getSaveData()
    local saveEffects = {}
    for i, effect in ipairs(self.effects) do
        table.insert(saveEffects, effect:getSaveData())
    end
    return {effects = saveEffects, immunities = self.immunities, inflictions = self.inflictions} -- get the save data table for the effect manager
end
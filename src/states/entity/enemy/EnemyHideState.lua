--[[
    Enemy Hide State: an entity state specific to Camo enemies that defines behavior when in its hidden form.
    @author Saverton
]]

EnemyHideState = Class{__includes = EntityBaseState}

function EnemyHideState:init(entity) 
    self.entity = entity
    self.animate = false
    self.entity:changeAnimation('hide') -- set enemy's animation as hiding
    self.entity.isHiding = true
end
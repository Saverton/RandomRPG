--[[
    Base state for entity behavior.
    @author Saverton
]]

EntityBaseState = Class{__includes = BaseState}

function EntityBaseState:init(entity)
    self.entity = entity
end

function EntityBaseState:update(dt)

end

function EntityBaseState:render(x, y)
    local anim = self.entity.animations[self.entity.currentAnimation]
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim.frames[self.entity.currentFrame]],
        x, y, DEFAULT_ENTITY_ROTATION, anim.xScale, 1)
end
--[[
    Behavior for all animations in the game.
    @author Saverton
]]

Animation = Class{}

function Animation:init(name, startAnim)
    self.name = name
    self.currentAnimation = startAnim
    self.texture = ANIMATION_DEFS[self.name][self.currentAnimation].texture
    self.frames = ANIMATION_DEFS[self.name][self.currentAnimation].frames
    self.interval = ANIMATION_DEFS[self.name][self.currentAnimation].interval or 1
    self.looping = ANIMATION_DEFS[self.name][self.currentAnimation].looping
    if self.looping == nil then
        self.looping = true
    end
    self.currentFrame = 1
    self.timer = self.interval
end

function Animation:update(dt)
    if #self.frames > 1 then
        self.timer = math.max(0, self.timer - dt) 

        if self.timer == 0 then
            if self.looping then
                self.currentFrame = (self.currentFrame % #self.frames) + 1
            else
                self.currentFrame = math.min(self.currentFrame + 1, #self.frames)
            end
            self.timer = self.interval
        end
    end
end

function Animation:changeAnimation(newAnim)
    assert(ANIMATION_DEFS[self.name][newAnim])
    self.currentAnimation = newAnim
    self.texture = ANIMATION_DEFS[self.name][self.currentAnimation].texture
    self.frames = ANIMATION_DEFS[self.name][self.currentAnimation].frames
    self.interval = ANIMATION_DEFS[self.name][self.currentAnimation].interval or 1
    self.looping = ANIMATION_DEFS[self.name][self.currentAnimation].looping
    if self.looping == nil then
        self.looping = true
    end
    self.currentFrame = 1
    self.timer = self.interval
end

function Animation:render(x, y, rot, xScale, yScale)
    local sx = (ANIMATION_DEFS[self.name][self.currentAnimation].xScale or 1) * (xScale or 1)
    local sy = (ANIMATION_DEFS[self.name][self.currentAnimation].yScale or 1) * (yScale or 1)
    if sx < 0 then
        x = x + 16
    end if sy < 0 then
        y = y + 16
    end
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frames[self.currentFrame]], 
        math.floor(x or 0), math.floor(y or 0), (rot or 0), (xScale or 1) * (ANIMATION_DEFS[self.name][self.currentAnimation].xScale or 1), (yScale or 1))
end
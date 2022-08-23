--[[
    Base class for all entities in the game.
    attributes: x, y, width, height, stateMachine, animations, hp, speed, defense, onDeath(), direction, currentFrame,
        animationTimer
    @author Saverton
]]

Entity = Class{}

function Entity:init(def)
    self.x = def.x or 0
    self.y = def.y or 0
    self.width = def.width or DEFAULT_ENTITY_WIDTH
    self.height = def.height or DEFAULT_ENTITY_HEIGHT
    
    self.stateMachine = def.stateMachine or StateMachine({
        ['Base'] = function() return BaseState() end
    })

    self.animations = self:generateAnimations(def.animations)
    self.currentAnimation = self.animations[1]
    self.currentFrame = 1
    self.timeSinceLastFrame = 0

    self.hp = def.hp or DEFAULT_HP
    self.speed = def.speed or DEFAULT_SPEED
    self.defense = def.defense or DEFAULT_DEFENSE

    self.onDeath = def.onDeath or function() end
end

function Entity:generateAnimations(animations)
    local returnAnimations = {}

    for i, animation in pairs(animations) do
        returnAnimations[i] = {
            texture = animation.texture or 'entities',
            frames = animation.frames or {1},
            speed = animation.speed or DEFAULT_ANIMATION_SPEED,
            xScale = animation.xScale or 1
        }
    end

    return returnAnimations
end

function Entity:update(dt) 
    self.stateMachine:update(dt)

    -- update frames
    if self.stateMachine.animate then
        self:updateFrames(dt)
    end
end

function Entity:changeState(name)
    self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
    self.currentFrame = 1
end

function Entity:updateFrames(dt)
    -- update frames
    self.timeSinceLastFrame = self.timeSinceLastFrame + dt
    if self.timeSinceLastFrame > self.currentAnimation.speed then
        self.currentFrame = self.currentFrame + 1
        if self.currentFrame > #self.currentAnimation.frames then
            self.currentFrame = 1
        end
    end
end

function Entity:collides(target)
    return not (self.x > target.x + target.width or self.x + self.width < target.x or
        self.y > target.y + target.height or self.y + self.height < target.y)
end

function Entity:render(camera)
    local onScreenX = self.x - camera.x
    local onScreenY = self.y - camera.y
    -- base function for drawing an entity
    self.stateMachine:render(onScreenX, onScreenY)
    --love.graphics.draw(self.animations[self.currentAnimation].texture, 
        --self.animations[self.currentAnimation].texture[self.animations[self.currentAnimation].frames[self.currentFrame]],
        --self.x + MAP_OFFSET_X, self.y + MAP_OFFSET_Y, DEFAULT_ENTITY_ROTATION, )
end
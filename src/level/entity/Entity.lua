--[[
    Base class for all entities in the game.
    attributes: x, y, width, height, stateMachine, animations, hp, speed, defense, onDeath(), direction, currentFrame,
        animationTimer
    @author Saverton
]]

Entity = Class{}

function Entity:init(def, level)
    self.x = def.x or 1
    self.y = def.y or 1
    self.width = def.width or DEFAULT_ENTITY_WIDTH
    self.height = def.height or DEFAULT_ENTITY_HEIGHT
    self.direction = START_DIRECTION

    self.level = level

    self.defs = def.defs
    
    self.stateMachine = StateMachine(def.stateMachine) or StateMachine({
        ['Base'] = function() return BaseState() end
    })

    self.animations = def.animations
    self.currentAnimation = def.startAnim or 'idle-right'
    self.currentFrame = 1
    self.timeSinceLastFrame = 0

    self.hp = def.hp or DEFAULT_HP
    self.speed = def.speed or DEFAULT_SPEED
    self.defense = def.defense or DEFAULT_DEFENSE

    self.onDeath = def.onDeath or function() end
end

function Entity:update(dt) 
    self.stateMachine:update(dt)

    -- update frames
    if #self.animations[self.currentAnimation].frames > 1 then
        self:updateFrames(dt)
    end
end

function Entity:changeState(name)
    self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
    assert(self.animations[name])
    self.currentAnimation = name
    self.currentFrame = 1
end

function Entity:updateFrames(dt)
    -- update frames
    local anim = self.animations[self.currentAnimation]
    self.timeSinceLastFrame = self.timeSinceLastFrame + dt
    if self.timeSinceLastFrame > anim.interval then
        self.currentFrame = self.currentFrame + 1
        if self.currentFrame > #anim.frames then
            self.currentFrame = 1
        end
        self.timeSinceLastFrame = 0
    end
end

function Entity:collides(target)
    return not (self.x > target.x + target.width or self.x + self.width < target.x or
        self.y > target.y + target.height or self.y + self.height < target.y)
end

function Entity:render(camera)
    local onScreenX = math.floor(self.x - camera.x)
    if self.animations[self.currentAnimation].xScale == -1 then
        onScreenX = onScreenX + self.width
    end
    local onScreenY = math.floor(self.y - camera.y)
    -- base function for drawing an entity
    self.stateMachine:render(onScreenX, onScreenY)
    --love.graphics.draw(self.animations[self.currentAnimation].texture, 
        --self.animations[self.currentAnimation].texture[self.animations[self.currentAnimation].frames[self.currentFrame]],
        --self.x + MAP_OFFSET_X, self.y + MAP_OFFSET_Y, DEFAULT_ENTITY_ROTATION, )
end
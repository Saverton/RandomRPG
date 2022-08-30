--[[
    Base class for all entities in the game.
    attributes: x, y, width, height, stateMachine, animations, hp, speed, defense, onDeath(), direction, currentFrame,
        animationTimer
    @author Saverton
]]

Entity = Class{}

function Entity:init(def, level, pos)
    self.x = (pos.x * TILE_SIZE) or 1
    self.y = (pos.y * TILE_SIZE) or 1
    self.width = def.width or DEFAULT_ENTITY_WIDTH
    self.height = def.height or DEFAULT_ENTITY_HEIGHT
    self.direction = START_DIRECTION

    self.level = level or nil
    
    self.stateMachine = nil

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
    return Collide(self, target)
end

function Entity:damage(amount)
    self.hp = math.max(0, self.hp - (math.max(1, amount - self.defense)))
end

function Entity:render(camera, offsetX, offsetY)
    -- determine the on screen x and y positions of the entity based on the camera, any
    -- drawing manipulation, or offsets.
    local xScale = self.animations[self.currentAnimation].xScale or 1
    if offsetX == nil then
        offsetX = 0
    end
    if offsetY == nil then
        offsetY = 0
    end
    local onScreenX = math.floor(self.x - camera.x + (xScale * offsetX))
    if xScale == -1 then
        onScreenX = onScreenX + self.width
    end
    local onScreenY = math.floor(self.y - camera.y + offsetY)

    -- draw the entity at the specified x and y.
    self.stateMachine:render(onScreenX, onScreenY)
end
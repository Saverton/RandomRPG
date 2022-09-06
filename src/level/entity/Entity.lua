--[[
    Base class for all entities in the game.
    attributes: x, y, width, height, stateMachine, animations, hp, speed, defense, onDeath(), direction, currentFrame,
        animationTimer
    @author Saverton
]]

Entity = Class{}

function Entity:init(def, level, pos, off)
    self.name = def.name

    --positioning
    if off == nil then
        off = {
            x = 0,
            y = 0
        }
    end
    self.x = (((pos.x - 1) * TILE_SIZE) + (off.x))
    self.y = (((pos.y - 1) * TILE_SIZE) + (off.y))
    self.width = def.width or DEFAULT_ENTITY_WIDTH
    self.height = def.height or DEFAULT_ENTITY_HEIGHT
    self.direction = START_DIRECTION
    self.xOffset = def.xOffset or 0
    self.yOffset = def.yOffset or 0

    -- reference to level
    self.level = level or nil
    
    -- owned stateMachine
    self.stateMachine = nil

    -- animations
    self.animations = def.animations
    self.currentAnimation = def.startAnim or 'idle-right'
    self.currentFrame = 1
    self.timeSinceLastFrame = 0

    -- item management
    self.items = {}
    self.heldItem = 1
    self.ammo = START_AMMO
end

function Entity:update(dt)
    self.stateMachine:update(dt)

    -- update frames
    if #self.animations[self.currentAnimation].frames > 1 then
        self:updateFrames(dt)
    end

    --update Item use timer
    if self.items[self.heldItem] ~= nil then
        self.items[self.heldItem]:update(dt)
    end
end

function Entity:changeState(name, params)
    self.stateMachine:change(name, params)
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

function Entity:setHeldItem(index)
    if self.items[index] ~= nil then
        self.heldItem = index
    end
end

function Entity:render(camera)
    -- determine the on screen x and y positions of the entity based on the camera, any
    -- drawing manipulation, or offsets.
    local xScale = self.animations[self.currentAnimation].xScale or 1
    local onScreenX = math.floor(self.x - camera.x + (xScale * self.xOffset))
    local onScreenY = math.floor(self.y - camera.y + self.yOffset)

    -- fix player sprite being off by 16 pixels
    if xScale == -1 then
        onScreenX = onScreenX + self.width
    end

    -- draw the entity at the specified x and y.
    self.stateMachine:render(onScreenX, onScreenY)
    love.graphics.setColor(1, 1, 1, 1)

    --debug: draw hitbox
    --love.graphics.rectangle('line', self.x - camera.x, self.y - camera.y, self.width, self.height)

    --print simple string if showstats is true
    local mouseX, mouseY = push:toGame(love.mouse.getPosition())
    if (mouseX ~= nil and mouseY ~= nil) and Collide(self, {x = mouseX + camera.x, y = mouseY + camera.y, width = 1, height = 1}) then
        love.graphics.setFont(gFonts['small'])
        local message = ''
        if self.currenthp ~= nil then
            message = ENTITY_DEFS[self.name].displayName .. ': (' .. tostring(self.currenthp) .. ' / ' .. tostring(self:getHp()) .. ')'
        elseif self.npcName ~= nil then
            message = self.npcName
        end
        love.graphics.setColor({0, 0, 0, 1})
        love.graphics.print(message, math.floor(self.x - camera.x + 1), math.floor(self.y - camera.y - 15 + 1))
        love.graphics.setColor({1, 1, 1, 1})
        love.graphics.print(message, math.floor(self.x - camera.x), math.floor(self.y - camera.y - 15))
    end
end

function Entity:checkCollision()
    local tilesToCheck = {}
    -- add one to each to match feature map indexes
    local mapX, mapY, mapXB, mapYB = math.floor((self.x + PLAYER_HITBOX_X_OFFSET) / TILE_SIZE) + 1, math.floor((self.y + PLAYER_HITBOX_Y_OFFSET) / TILE_SIZE) + 1, 
        math.floor((self.x + self.width + PLAYER_HITBOX_XB_OFFSET) / TILE_SIZE) + 1, math.floor((self.y + self.height + PLAYER_HITBOX_YB_OFFSET) / TILE_SIZE) + 1
    local collide = false

    if self.direction == 'up' then
        tilesToCheck = {{mapX, mapY}, {mapXB, mapY} }
    elseif self.direction == 'right' then
        tilesToCheck = {{mapXB, mapY}, {mapXB, mapYB}}
    elseif self.direction == 'down' then
        tilesToCheck = {{mapX, mapYB}, {mapXB, mapYB}}
    elseif self.direction == 'left' then
        tilesToCheck = {{mapX, mapY}, {mapX, mapYB}}
    end

    for i, coord in pairs(tilesToCheck) do
        if coord[1] < 1 or coord[1] > self.level.map.size or coord[2] < 1 or coord[2] > self.level.map.size then
            goto continue
        end
        local feature = self.level.map.featureMap[coord[1]][coord[2]]
        local tile = self.level.map.tileMap.tiles[coord[1]][coord[2]]
        if (feature ~= nil and FEATURE_DEFS[feature.name].isSolid) or tile.barrier then
            collide = true
            break
        end
        ::continue::
    end

    return collide
end

function Entity:getItem(item)
    local itemData = ITEM_DEFS[item.name]
    if itemData.type ~= 'pickup' then
        if itemData.stackable then
            local insertIndex = GetIndex(self.items, item.name)
            if insertIndex ~= -1 then
                self.items[insertIndex].quantity = self.items[insertIndex].quantity + item.quantity
            else
                table.insert(self.items, item)
            end
        else
            table.insert(self.items, item)
        end
    end
end

function Entity:useHeldItem()
    if (self.heldItem > #self.items) then
        return
    end
    local item = self.items[self.heldItem]
    if item ~= nil and item.useRate == 0 then
        item:use()
    end
end
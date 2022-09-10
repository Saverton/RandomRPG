--[[
    Base class for all entities in the game.
    attributes: x, y, width, height, stateMachine, animations, hp, speed, defense, onDeath(), direction, currentFrame,
        animationTimer
    @author Saverton
]]

Entity = Class{}

function Entity:init(def, level, pos)
    self.name = def.name
    self.animName = def.animName or self.name

    --entity positioning
    self.x = (((pos.x - 1) * TILE_SIZE) + (pos.ox))
    self.y = (((pos.y - 1) * TILE_SIZE) + (pos.oy))
    self.direction = START_DIRECTION
    self.xOffset = def.xOffset or 0
    self.yOffset = def.yOffset or 0

    -- reference to level
    self.level = level or nil
    
    -- owned stateMachine
    self.stateMachine = nil

    -- animations
    self.animator = Animation(self.animName, def.startAnim or 'idle-right')

    -- item management
    self.items = {}
    if def.items ~= nil then
        for i, item in ipairs(def.items) do
            table.insert(self.items, Item(item.name, self, item.quantity))
        end
    end
    self.heldItem = 1

    -- move speed
    self.speed = def.speed or DEFAULT_SPEED
end

function Entity:update(dt)
    -- update entity activity held in state machine
    self.stateMachine:update(dt)

    -- update frames
    self.animator:update(dt)

    --update held item
    if self.items[self.heldItem] ~= nil then
        self.items[self.heldItem]:update(dt)
    end
end

function Entity:changeState(name, params)
    self.stateMachine:change(name, params)
end

function Entity:changeAnimation(name)
    self.animator:changeAnimation(name)
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
    -- determine the on screen x and y positions of the entity based on the camera, any drawing manipulation, or offsets.
    local onScreenX = math.floor(self.x - camera.x + self.xOffset)
    local onScreenY = math.floor(self.y - camera.y + self.yOffset)

    -- draw the entity at the specified x and y according to stateMachine behavior
    self.stateMachine:render(onScreenX, onScreenY)
    -- set color back to default in case it was changed
    love.graphics.setColor(1, 1, 1, 1)

    --print simple string if showstats is true
    local mouseX, mouseY = push:toGame(love.mouse.getPosition())
    if (mouseX ~= nil and mouseY ~= nil) and Collide(self, {x = mouseX + camera.x, y = mouseY + camera.y, width = 1, height = 1}) then
        love.graphics.setFont(gFonts['small'])
        local message = self:getDisplayMessage()
        love.graphics.setColor({0, 0, 0, 1})
        love.graphics.print(message, math.floor(self.x - camera.x + 1), math.floor(self.y - camera.y - 15 + 1))
        love.graphics.setColor({1, 1, 1, 1})
        love.graphics.print(message, math.floor(self.x - camera.x), math.floor(self.y - camera.y - 15))
    end

    --debug: draw hitbox
    --love.graphics.rectangle('line', self.x - camera.x, self.y - camera.y, self.width, self.height)
end

function Entity:checkCollision()
    local tilesToCheck = {}
    -- get the coordinates of the entity's top left and bottom right coords, convert to map coords, add one to each to match feature map indexes
    local mapX, mapY, mapXB, mapYB = math.floor((self.x) / TILE_SIZE) + 1, math.floor((self.y) / TILE_SIZE) + 1, 
        math.floor((self.x + self.width) / TILE_SIZE) + 1, math.floor((self.y + self.height) / TILE_SIZE) + 1
    local collide = false

    -- create locals for the dx and dy values: if this is a combat entity, then check if it is pushed, then add the movement of the entity
    local dx = 0
    local dy = 0
    if self.pushed then
       dx = self.pushdx
       dy = self.pushdy 
    end
    dx = dx + (DIRECTION_COORDS[DIRECTION_TO_NUM[self.direction]].x * self:getSpeed())
    dy = dy + (DIRECTION_COORDS[DIRECTION_TO_NUM[self.direction]].y * self:getSpeed())

    -- determine the map coordinates that need to be checked based on the movement direction
    tilesToCheck = {}
    if dy < 0 then
        table.insert(tilesToCheck, {x = mapX, y = mapY})
        table.insert(tilesToCheck, {x = mapXB, y = mapY})
    end if dx > 0 then
        table.insert(tilesToCheck, {x = mapXB, y = mapY})
        table.insert(tilesToCheck, {x = mapXB, y = mapYB})
    end if dy > 0 then
        table.insert(tilesToCheck, {x = mapX, y = mapYB})
        table.insert(tilesToCheck, {x = mapXB, y = mapYB})
    end if dx < 0 then
        table.insert(tilesToCheck, {x = mapX, y = mapY})
        table.insert(tilesToCheck, {x = mapX, y = mapYB})
    end

    for i, coord in pairs(tilesToCheck) do
        -- ensure that collision check coordinate is on the map
        if coord.x < 1 or coord.x > self.level.map.size or coord.y < 1 or coord.y > self.level.map.size then
            goto continue
        end
        local feature = self.level.map.featureMap[coord.x][coord.y]
        local tile = self.level.map.tileMap[coord.x][coord.y]
        -- determine if we collide with something that stops us
        if (feature ~= nil and FEATURE_DEFS[feature.name].isSolid) or TILE_DEFS[tile.name].barrier then
            collide = true
            break
        end
        -- if this is a player and the feature is an active gateway, enter the gateway
        if self.isPlayer and (feature ~= nil and FEATURE_DEFS[feature.name].gateway and feature.active) then
            feature:onEnter(self.level)
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
    local used = false
    if not (self.heldItem > #self.items) then
        local item = self.items[self.heldItem]
        if item ~= nil and item.useRate == 0 then
            item:use()
            used = true
        end
    end
    return used
end
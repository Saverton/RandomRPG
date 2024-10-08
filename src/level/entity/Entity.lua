--[[
    Entity Class: defines the behavior and attributes shared by all Entities in the game, this class is never instantiated on it's own.
    @author Saverton
]]

Entity = Class{}

function Entity:init(level, definitions, position)
    self.level = level -- reference to the level this entity belongs in
    self.name = definitions.name -- the name of this entity
    self.animationName = definitions.animationName or self.name -- the name for this entity's animation
    self.xOffset, self.yOffset = definitions.xOffset or 0, definitions.yOffset or 0 -- set the entity's offsets
    self.width, self.height = definitions.width or DEFAULT_ENTITY_WIDTH, definitions.height or DEFAULT_ENTITY_HEIGHT -- set entity's width and height
    self.stateName = 'idle' -- the name of the current state that this entity is in
    self.animator = Animation(self.animationName, definitions.startAnimation or 'idle-right') -- the animator used to display this entity
    self:initiateInventory(definitions.items or {}) -- initiate the inventory of this entity
    self.speed = definitions.speed or DEFAULT_SPEED -- set the move speed for this entity
    self:setPosition(position) -- set the entity's spawning position
end

-- update each of the components of this entity
function Entity:update(dt)
    self.stateMachine:update(dt) -- update the entity's statemachine, where most activity is held
    self.animator:update(dt) -- update the entity's animation
    if self:getHeldItem() ~= nil then
        self:getHeldItem():update(dt) --update held item's use timer
    end
end

-- render this entity
function Entity:render(camera)
    -- determine the on screen x and y positions of the entity based on the camera or offsets.
    local onScreenX, onScreenY = self:getOnScreenPosition(camera)
    self.stateMachine:render(onScreenX, onScreenY) -- draw the entity at the specified x and y according to stateMachine behavior
    love.graphics.setColor(1, 1, 1, 1) -- set color back to default white in case it was changed
    local mouseX, mouseY = LibPush:toGame(love.mouse.getPosition()) -- get mouse position
    if self:statsVisible() and (mouseX ~= nil and mouseY ~= nil) and Collide(self, {x = mouseX + camera.x, y = mouseY + camera.y, width = 1, height = 1}) then
        self:printInfoTag(onScreenX, onScreenY)
    end -- if the mouse collides with this entity, print an informational tag above the entity
end

-- set the entity's starting position and orientation according to a position table.
function Entity:setPosition(position)
    -- set the x and y position
    self.x, self.y = (((position.x - 1) * TILE_SIZE) + (position.xOffset or 0)), (((position.y - 1) * TILE_SIZE) + (position.yOffset or 0))
    self:setDirection(START_DIRECTION)
end

function Entity:getMapPosition()
    return {
        x = math.floor(self.x / TILE_SIZE),
        y = math.floor(self.y / TILE_SIZE)
    }
end

-- initiate the inventory with a list of items.
function Entity:initiateInventory(items)
    self.items = {} -- set this entity's inventory to empty
    for i, item in ipairs(items) do
        Entity.giveItem(self, Item(item.name, self, item.quantity)) -- add each item into inventory from items list
    end
    self.heldItem = 1 -- set the held Item to 1
end

-- change the state of this entity's stateMachine, pass parameters onward
function Entity:changeState(name, parameters)
    self.stateMachine:change(name, parameters)
    self.stateName = name -- set the entity's stateName to the new state's name
end

-- change the animation of this entity's animator
function Entity:changeAnimation(name)
    self.animator:changeAnimation(name)
end

function Entity:setDirection(dir)
    if self.direction == dir then return end

    self.direction = dir

    if dir == 'left' then
        self.dirX, self.dirY = -1, 0
    elseif dir == 'right' then
        self.dirX, self.dirY = 1, 0
    elseif dir == 'up' then
        self.dirX, self.dirY = 0, -1
    elseif dir == 'down' then
        self.dirX, self.dirY = 0, 1
    else
        error('invalid direction name => ' .. dir)
    end

    self:changeAnimation(self.stateName .. '-' .. self.direction) -- change the entity's animation to reflect its new direction
end

function Entity:setDirXY(dirX, dirY)
    self.dirX, self.dirY = dirX, dirY
end

-- change the entity's direction to a random direction
function Entity:setRandomDirection()
    self:setDirection(DIRECTIONS[math.random(4)])
end

-- change the direction of the entity by shifting it by a certain amount (+ = clockwise, - = counterclockwise)
function Entity:shiftDirection(shiftAmount)
    local currDir = DIRECTION_TO_NUM[self.direction]
    local newDir = (((currDir - 1) + shiftAmount) % 4) + 1
    self:setDirection(DIRECTIONS[newDir])
end

-- return true if this entity collides with the target, false otherwise
function Entity:collides(target)
    return Collide(self, target)
end

-- set this entity's currently held item to a new index
function Entity:setHeldItem(index)
    if self.items[index] ~= nil then
        self.heldItem = index
    end
end

-- insert a new item into the entity's inventory
function Entity:giveItem(item)
    local itemData = ITEM_DEFS[item.name] -- reference to item's definition table
    if itemData.type == 'pickup' then -- check if the item is a pickup
        itemData.onPickup(self, item.quantity) -- register as a pickup
    elseif itemData.stackable then -- determine if the item is able to be stacked
        self:giveStackableItem(item) -- add the item as a stackable
    else -- add the new items as a new index if not stackable
        table.insert(self.items, item)
    end
end

-- insert a new stackable item into the entity's inventory
function Entity:giveStackableItem(item)
    local insertIndex = GetIndex(self.items, item.name) -- find if the item already exists in the entity's inventory
    if insertIndex ~= -1 then -- if it does, add the amount of new items to the existing quantity
        self.items[insertIndex].quantity = self.items[insertIndex].quantity + item.quantity
    else -- add the new item.
        table.insert(self.items, item)
    end
end

-- use the currently held item.
function Entity:useHeldItem()
    local successful = false -- tracks if the item was successfully used or not
    if not (self.heldItem > #self.items or self.heldItem == 0) then -- ensure that the held item exists
        successful = self.items[self.heldItem]:use() -- use the item
    end
    return successful
end

-- return true if this entity's movement causes a collision with the map, false otherwise
function Entity:checkCollisionWithMap(dt, x, y)
    local checkList = self:getCollisionCheckList(dt, x or self.x, y or self.y) -- get a list of coordinates to check
    local map = self.level.map -- reference to the entity's level's map
    local isFlying = (self.npcName == nil and ENTITY_DEFS[self.name].isFlying) or false -- determines if features are checked in collisions
    for i, coordinate in pairs(checkList) do
        if coordinate.x < 1 or coordinate.x > map.width or coordinate.y < 1 or coordinate.y > map.height then
            goto skipThisCoordinate -- skip this check if the coordinate is not on the map
        end
        local feature = map.featureMap[coordinate.x][coordinate.y] or Feature('empty') -- the feature in this coordinate
        local tile = map.tileMap[coordinate.x][coordinate.y] -- definitions table for tile in this coordinate
        if (not isFlying and FEATURE_DEFS[feature.name].isSolid) or not tile:isHabitableTile() then
            return true -- determine if the entity collides with something that stops it
        end
        FEATURE_DEFS[feature.name].onCollide(self, feature) -- if this feature has an onCollide function, call it
        ::skipThisCoordinate:: -- go here if this coordinate should be skipped in checking
    end
    return false -- no collisions detected, return false
end

-- return a list of map coordinates to check for collision with.
function Entity:getCollisionCheckList(dt, x, y)
    local leftCol, rightCol, topRow, bottomRow = (math.ceil(x / TILE_SIZE)), (math.ceil((x + self.width) / TILE_SIZE)),
        (math.ceil(y / TILE_SIZE)), (math.ceil((y + self.height) / TILE_SIZE)) -- get the map coordinates of each side of this entity
    local dx, dy = self:getDirectionalVelocities(dt) -- get entity's directional velocity
    local checkList = {} -- the list of coordinates to be checked for collision
    if dx < 0 or dy < 0 then
        table.insert(checkList, {x = leftCol, y = topRow})
    end if dx > 0 or dy < 0 then
        table.insert(checkList, {x = rightCol, y = topRow})
    end if dx > 0 or dy > 0 then
        table.insert(checkList, {x = rightCol, y = bottomRow})
    end if dx < 0 or dy > 0 then
        table.insert(checkList, {x = leftCol, y = bottomRow})
    end -- add in coordinates according to the entity's x and y velocity
    return checkList
end

-- return the directional velocity for the x and y axis of this entity (dx = delta x, dy = delta y)
function Entity:getDirectionalVelocities(dt)
    local dx, dy = 0, 0 -- set base velocity as 0
    if self.pushManager ~= nil and self.pushManager.isPushed then
       dx, dy = self.pushManager.pushdx, self.pushManager.pushdy -- add in push velocity
    end
    dx, dy = dx + (DIRECTION_COORDS[DIRECTION_TO_NUM[self.direction]].x * (self:getSpeed() * dt)),
        dy + (DIRECTION_COORDS[DIRECTION_TO_NUM[self.direction]].y * (self:getSpeed() * dt)) -- add in the entity's movement velocity
    return dx, dy
end

-- print a message above the entity with information about it gathered according to its subclass
function Entity:printInfoTag(x, y)
    love.graphics.setFont(gFonts['small'])
    local message = self:getDisplayMessage()
    PrintWithShadow(message, x, y + INFO_TAG_Y_OFFSET)
end

-- return the onscreen position of this entity
function Entity:getOnScreenPosition(camera)
    return math.floor(self.x - camera.x + self.xOffset), math.floor(self.y - camera.y + self.yOffset)
end

-- return the entity's held item
function Entity:getHeldItem()
    return self.items[self.heldItem] -- returns held item or nil if none
end

-- return whether or not this entity's stats should be shown
function Entity:statsVisible()
    return true
end

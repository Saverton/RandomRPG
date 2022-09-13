--[[
    Player Class: defines behavior of the player that the user controls, has money, a hotbar, guis for health, mana, and exp, a list of held quests.
    @author Saverton
]]

Player = Class{__includes = CombatEntity}

function Player:init(level, definitions, position)
    CombatEntity.init(self, level, definitions, position) -- initiate a combat entity
    self.money = definitions.money or 0 -- player's currency
    self.questManager = QuestManager(definitions.quests) -- initiate a quest manager
    self:initiateGuis() -- initiate all gui elements of the player display
    if #self.items == 0 then -- if the player is starting, give him a wooden sword
        self:getItem(Item('wooden_sword', self, 1))
    end
end

-- update the player's components
function Player:update(dt)
    CombatEntity.update(self, dt) -- update the player's combat statistics
    if self.currentStats.hp <= 0 then --check for player's death
        self:dies()
    end
    self:setHeldItem(self:switchItem()) -- switches held item if the mouse wheel is scrolled
    if self.canUseItem and love.keyboard.wasPressed('space') then
        self:interact() -- if space is pressed, use current item or interact with npcs/features
    end
end

-- render the player
function Player:render(camera)
    if self.renderPlayer then -- check to see if the player should be rendered
        CombatEntity.render(self, camera)
    end
    self:renderGui() -- render gui elements of player display
end

-- initiate all gui parts for the player
function Player:initiateGuis()
    self.hotbar = self:getHotbar(3) -- player's hotbar gui
    self.hpBar = ProgressBar(PLAYER_BAR_X, PLAYER_HP_BAR_Y, PLAYER_BAR_WIDTH, PLAYER_HP_BAR_HEIGHT, {1, 0, 0, 1}) -- health bar
    self.manaBar = ProgressBar(PLAYER_BAR_X, PLAYER_MAGIC_BAR_Y, PLAYER_BAR_WIDTH, PLAYER_BAR_HEIGHT, {0, 0, 1, 1}) -- mana bar
    self.expBar = ProgressBar(PLAYER_BAR_X, PLAYER_EXP_BAR_Y, PLAYER_BAR_WIDTH, PLAYER_BAR_HEIGHT, {0, 1, 0, 1}) -- exp bar
end

-- return the new heldItem after the scroll updates
function Player:switchItem()
    local yScroll = GetYScroll() -- navigate between held items
    local newItem = self.heldItem
    if yScroll ~= 0 then
        gSounds['gui']['menu_blip_1']:play() -- play switch sound
        newItem = (((self.heldItem - 1) - yScroll) % (#self.hotbar) + 1) -- set new held item
    end
    for i = 1, #self.hotbar, 1 do -- check if number keys were pressed
        if love.keyboard.wasPressed(tostring(i)) then
            newItem = i
        end
    end
    return newItem
end

-- run the appropriate interact function based on the conditions of the player.
function Player:interact()
    local checkBox = {x = self.x + (DIRECTION_COORDS[DIRECTION_TO_NUM[self.direction]].x * TILE_SIZE) - ((TILE_SIZE - self.width) / 2),
            y = self.y + (DIRECTION_COORDS[DIRECTION_TO_NUM[self.direction]].y * TILE_SIZE),
            width = TILE_SIZE, height = TILE_SIZE} -- set checkbox to square in front of player
    if self:interactWithNPC(checkBox) then -- interact with any npc in the checkbox
    elseif self:useHeldItem() then  -- use the currently held item
        self:interactWithMap(checkBox) -- interact with the map at selected coordinates
    elseif self.items[self.heldItem] == nil then
        self:interactWithMap(checkBox) -- interact with the map at selected coordinates
    end 
end

-- render player gui elements
function Player:renderGui()
    for i, slot in ipairs(self.hotbar) do --render each Item Hotbar Panel
        self:renderHotbarSlot(slot, i)
    end
    love.graphics.setFont(gFonts['small']) -- set font to small
    PrintWithShadow('Ammo: ' .. tostring(self:getAmmoCount()), PLAYER_TEXT_POS_X, AMMO_TEXT_POS_Y) -- render ammo count
    PrintWithShadow('Money: ' .. tostring(self.money), PLAYER_TEXT_POS_X,  MONEY_TEXT_POS_Y) -- render money amount
    self.hpBar:render((self.currenthp / self:getHp())) -- render hp bar
    self.manaBar:render((self.currentmagic / self:getMagic())) -- render mana bar
    self.expBar:render(self.statLevel:getExpRatio()) -- render exp bar
    PrintWithShadow('\'i\' = Open Inventory', TIPTEXT_X, TIPTEXT_Y) -- print inventory text
    if #self.quests > 0 then
        PrintWithShadow('\'q\' = Open Quests', TIPTEXT_X, TIPTEXT_Y - 10) -- print quest text
    end
end

-- return the amount of ammo that the player has in his inventory
function Player:getAmmoCount()
    local ammoCount = 0
    local ammoIndex = GetIndex(self.items, 'ammo') -- find index of ammo in inventory
    if ammoIndex ~= -1 then -- determine if player has ammo
        ammoCount = self.items[ammoIndex].quantity -- determine the quantity if the player has ammo
    end
    return ammoCount
end

function Player:renderHotbarSlot(slot, index)
    local opacity = 0.5 -- transparent by default
    local item = self.items[index] -- reference to this slot's item
    if index == self.heldItem then
        opacity = 1 -- if this is the held item, set opacity to opaque
    end
    slot:render(opacity) -- render the panel
    if item ~= nil then  -- make sure item exists
        item:render(slot.x + 2, slot.y + 2) -- render the item
        if item.quantity > 1 then
            love.graphics.printf(self.items[index].quantity, slot.x, slot.y + 12, 18, "right") -- render item quantity
        end
    end
    if index == self.heldItem and self.items[self.heldItem] ~= nil then -- check if this is the held item
        love.graphics.setColor(1, 1, 1, 0.25) -- draw a mostly transparent rectangle to represent item use timer
        love.graphics.rectangle('fill', slot.x, slot.y + (((ITEM_DEFS[self.items[self.heldItem].name].useRate - self.items[self.heldItem].useRate) / ITEM_DEFS[self.items[self.heldItem].name].useRate) * slot.height), 
            slot.width, slot.height * (self.items[self.heldItem].useRate / ITEM_DEFS[self.items[self.heldItem].name].useRate))
        love.graphics.setColor(1, 1, 1, 1) -- reset color to white
    end
end

-- create a hotbar for the player
function Player:getHotbar(size)
    local hotbar = {} -- set an empty hotbar
    for i = 1, size, 1 do -- add <size> panels to the hotbar
        table.insert(hotbar, i, Panel(HOTBAR_X, HOTBAR_Y + ((i - 1) * (HOTBAR_MARGIN + HOTBAR_PANEL_SIZE)), HOTBAR_PANEL_SIZE, HOTBAR_PANEL_SIZE))
    end
    return hotbar
end

-- given an ordered list of item names and old item indexes, reorder the inventory to match the new order of the sort list
function Player:sortInventory(sortList)
    local newItems = {} -- table to be set as new inventory list
    for i, slot in ipairs(sortList) do -- add the items into the new list in order based on the item in the oldIndex in the old inventory
        table.insert(newItems, self.items[slot.oldIndex]) 
    end
    self.items = newItems
end

-- interact with any npcs that collide with the checkbox
function Player:interactWithNPC(checkBox)
    for i, npc in pairs(self.level.npcManager.npcs) do -- parse through each npc
        if npc.despawnTimer == -1 and Collide(npc, checkBox) then -- if the npc is in the checkBox and the npc is not departing, interact
            npc:interact(self)
            return true -- npc was interacted with
        end
    end
    return false -- npc was not interacted with
end

-- interact with the map features and tiles in the checkbox
function Player:interactWithMap(checkBox)
    local map = self.level.map -- reference to map
    local startCol, startRow = math.max(1, math.ceil(checkBox.x / TILE_SIZE)), math.max(1, math.ceil(checkBox.y / TILE_SIZE)) 
        -- set the upper left corner of the checkbox as the starting point for the tile checks
    for col = startCol, math.min(map.size, startCol + 1), 1 do
        for row = startRow, math.min(map.size, startRow + 1), 1 do
            local feature = map.featureMap[col][row] -- this index's feature
            local tile = map.tileMap[col][row] -- this index's tile
            if feature ~= nil and FEATURE_DEFS[feature.name].onInteract(self, map, col, row) then -- if a feature exists, interact with it
                goto stop_checking -- if the interaction returns true, stop checking for things to interact with
            elseif TILE_DEFS[tile.name].onInteract(self, map, col, row) then
                goto stop_checking -- if the interaction returns true, stop checking for things to interact with
            end
        end
    end
    ::stop_checking:: -- label to jump to if an interaction executes properly
end

-- returns a list of selections with their onSelect function set to the onSelectFunction parameter
function Player:getInventorySelections(onSelectFunction)
    local selectionList = {} -- set list as empty
    for i, item in ipairs(self.items) do -- create an index for each item
        local displayText = ITEM_DEFS[item.name].displayName .. item:getQuantityText() -- display text for selection
        table.insert(selectionList, Selection(item.name, onSelectFunction, i, displayText)) -- add this selection to the list
    end
    table.insert(selectionList, Selection('Close', function() gStateStack:pop() end)) -- add a close index at the end
    return selectionList
end

-- remove any items from the inventory that have a quantity of 0
function Player:updateInventory()
    for i, item in pairs(self.items) do -- parse through all items
        if item.quantity <= 0 then -- check item quantity
            table.remove(self.items, i)
        end
    end
end

-- try to sell the item at a certain index to a shop
function Player:tryToSell(index, shop, menu) -- menu = reference to the menu used to select this
    local item = self.items[index] -- item to be sold
    if not ITEM_DEFS[item.name].stackable then
        gStateStack:push(ConfirmState(MENU_DEFS['confirm'], {
            onConfirm = function() self:sell(index, shop, menu) end -- ask to confirm sale
        }))
    else
        self:sell(index, shop, menu) -- sell without confimation
    end
end

-- actually make the selling transaction with a shop
function Player:sell(index, shop, menu)
    local item = self.items[index] -- reference to item
    self.money = self.money + math.max(item.price.sell + shop.sellDiff, 0) -- give money for sell price
    item.quantity = item.quantity - 1 -- remove item
    if item.quantity == 0 then
        self:updateInventory() -- update inventory to remove 0 quantity items
        gStateStack:pop() -- remove shop sell item menu
        menu.selections = shop:getPlayerInventorySelections( -- set new selection list for item sell list.
            function(subMenuState, otherMenu) 
                gStateStack:push(MenuState(MENU_DEFS['shop_sell_item'], {parent = {shop = subMenuState, menu = otherMenu}})) -- menu to open on selection
            end
        )
    end
end

-- called when player dies, calls up to combatEntity
function Player:dies()
    CombatEntity.dies(self) -- call combat entity function
    self.renderPlayer = false -- stop rendering player
    gStateStack:push(DeathAnimationState(self, self.x - self.level.camera.x + self.xOffset, self.y - self.level.camera.y + self.yOffset))
        -- play the player's death animation
end
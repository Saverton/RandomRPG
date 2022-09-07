--[[
    Player Class: defines behavior of the player that the user controls.
    attributes: x, y, width, height, onDeath()
]]

Player = Class{__includes = CombatEntity}

function Player:init(def, level, pos, off)
    --self.statLevel = def.statLevel or 1

    CombatEntity.init(self, def, level, pos, off)

    self.pickupRange = PICKUP_RANGE

    self.money = def.money or 0

    self.hotbar = self:getHotbar(3)

    self.renderPlayer = true

    self.hpBar = ProgressBar(PLAYER_BAR_X, PLAYER_HP_BAR_Y, PLAYER_BAR_WIDTH, PLAYER_HP_BAR_HEIGHT, {1, 0, 0, 1})
    self.magicBar = ProgressBar(PLAYER_BAR_X, PLAYER_MAGIC_BAR_Y, PLAYER_BAR_WIDTH, PLAYER_BAR_HEIGHT, {0, 0, 1, 1})
    self.expBar = ProgressBar(PLAYER_BAR_X, PLAYER_EXP_BAR_Y, PLAYER_BAR_WIDTH, PLAYER_BAR_HEIGHT, {0, 1, 0, 1})

    self.quests = {}
    if def.quests ~= nil then
        for i, quest in ipairs(def.quests) do
            table.insert(self.quests, {name = quest.name, flags = quest.flags})
        end
    end

    -- player is starting, give a wooden sword
    if #self.items == 0 then
        self:getItem(Item('wooden_sword', self, 1))
    end
end

function Player:update(dt)
    --check for death
    if self.currenthp <= 0 then
        self:onDeath()
        self.renderPlayer = false
        gStateStack:push(DeathAnimationState(self, self.x - self.level.camera.x + self.xOffset, self.y - self.level.camera.y + self.yOffset))
    end

    CombatEntity.update(self, dt)

    -- navigate between held items
    local yScroll = GetYScroll()
    if yScroll ~= 0 then
        self:translateHeldItem(yScroll) 
    end

    for i = 1, #self.hotbar, 1 do
        if love.keyboard.wasPressed(tostring(i)) then
            self.heldItem = i
        end
    end


    -- if space is pressed, use current item or interact with npcs/features
    if self.canUseItem and love.keyboard.wasPressed('space') then
        local checkBox = {x = self.x + (DIRECTION_COORDS[DIRECTION_TO_NUM[self.direction]][1] * TILE_SIZE) - ((TILE_SIZE - self.width) / 2),
            y = self.y + (DIRECTION_COORDS[DIRECTION_TO_NUM[self.direction]][2] * TILE_SIZE),
            width = TILE_SIZE, height = TILE_SIZE
        }
        if self:interactWithNPC(checkBox) then
        elseif self:useHeldItem() then
        end
        self:interactWithMap(checkBox)
    end
end

function Player:render(camera)
    if self.renderPlayer then
        CombatEntity.render(self, camera)
    end
    -- debug: render player bounds
    -- love.graphics.rectangle('line', self.x - camera.x, self.y - camera.y, PLAYER_WIDTH, PLAYER_HEIGHT

    self:renderGui()

    -- debug: render player interaction box
    --local checkBox = {x = self.x + (DIRECTION_COORDS[DIRECTION_TO_NUM[self.direction]][1] * TILE_SIZE) - ((TILE_SIZE - self.width) / 2),
    --    y = self.y + (DIRECTION_COORDS[DIRECTION_TO_NUM[self.direction]][2] * TILE_SIZE),
    --    width = TILE_SIZE, height = TILE_SIZE
    --}
    --love.graphics.rectangle('line', checkBox.x - camera.x, checkBox.y - camera.y, checkBox.width, checkBox.height)
end

function Player:renderGui()
    --render Item Hotbar Panels
    for i, slot in ipairs(self.hotbar) do
        local opa = 0.5
        if i == self.heldItem then
            opa = 1
        end
        slot:render(opa)
        if self.items[i] ~= nil then
            self.items[i]:render(slot.x + 2, slot.y + 2)
        end
        if i == self.heldItem and self.items[self.heldItem] ~= nil then
            love.graphics.setColor(1, 1, 1, 0.25)
            love.graphics.rectangle('fill', slot.x, slot.y + (((ITEM_DEFS[self.items[self.heldItem].name].useRate - self.items[self.heldItem].useRate) / ITEM_DEFS[self.items[self.heldItem].name].useRate) * slot.height), 
                slot.width, slot.height * (self.items[self.heldItem].useRate / ITEM_DEFS[self.items[self.heldItem].name].useRate))
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    -- render ammo count
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print('Ammo: ' .. tostring(self.ammo), PLAYER_TEXT_POS_X + 1, AMMO_TEXT_POS_Y + 1)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Ammo: ' .. tostring(self.ammo), PLAYER_TEXT_POS_X, AMMO_TEXT_POS_Y)
    -- render money amount
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print('Money: ' .. tostring(self.money), PLAYER_TEXT_POS_X + 1, MONEY_TEXT_POS_Y + 1)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Money: ' .. tostring(self.money), PLAYER_TEXT_POS_X, MONEY_TEXT_POS_Y)

    --render health and magic bars
    self.hpBar:render((self.currenthp / self:getHp()))
    self.magicBar:render((self.currentmagic / self:getMagic()))
    self.expBar:render(self.statLevel:getExpRatio())

    --print tiptext
    if #self.items > 0 then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print('\'i\' = Open Inventory', TIPTEXT_X + 1, TIPTEXT_Y + 1)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print('\'i\' = Open Inventory', TIPTEXT_X, TIPTEXT_Y)
    end
    if #self.quests > 0 then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print('\'q\' = Open Quests', TIPTEXT_X + 1, TIPTEXT_Y + 1 - 10)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print('\'q\' = Open Quests', TIPTEXT_X, TIPTEXT_Y - 10)
    end
end

function Player:translateHeldItem(amount)
    love.audio.stop(gSounds['menu_blip_1'])
    love.audio.play(gSounds['menu_blip_1'])
    self.heldItem = (((self.heldItem - 1) - amount) % (#self.hotbar) + 1)
end

function Player:getHotbar(size)
    local hotbar = {}

    for i = 1, size, 1 do
        table.insert(hotbar, i, Panel(HOTBAR_X, HOTBAR_Y + ((i - 1) * (HOTBAR_MARGIN + HOTBAR_PANEL_SIZE)), HOTBAR_PANEL_SIZE, HOTBAR_PANEL_SIZE))
    end

    return hotbar
end

function Player:sortInventory(sortList)
    local newItems = {}

    for i, slot in ipairs(sortList) do
        table.insert(newItems, self.items[slot.oldIndex])
    end

    self.items = newItems
end

function Player:interactWithNPC(checkBox)
    for i, npc in pairs(self.level.npcManager.npcs) do
        if npc.despawnTimer == -1 and Collide(npc, checkBox) then
            npc:interact(self, npc)
            return true
        end
    end
    return false
end

function Player:interactWithMap(checkBox)
    local map = self.level.map
    local startCol = math.max(1, math.floor(checkBox.x / 16) - 1)
    local startRow = math.max(1, math.floor(checkBox.y / 16) - 1)
    for col = startCol, math.min(map.size, startCol + 3), 1 do
        for row = startRow, math.min(map.size, startRow + 3), 1 do
            local mapBox = {x = (col - 1) * TILE_SIZE, y = (row - 1) * TILE_SIZE, width = 16, height = 16}
            local feature = map.featureMap[col][row]
            local tile = map.tileMap.tiles[col][row]
            if feature ~= nil and Collide(checkBox, mapBox) then
                FEATURE_DEFS[feature.name].onInteract(self, map, col, row)
            end
            if Collide(checkBox, mapBox) then
                TILE_DEFS[tile.name].onInteract(self, map, col, row)
            end
        end
    end
end

function Player:updateFlags(checkFlags)
    for i, quest in pairs(self.quests) do
        for j, flag in pairs(quest.flags) do
            for k, check in pairs(checkFlags) do
                if flag.flag == check then
                    flag.counter = math.max(0, flag.counter - 1)
                end
            end
        end
    end
end

function Player:giveQuest(quest)
    if #self.quests < QUEST_LIMIT then
        table.insert(self.quests, quest)
        return true
    end
    return false
end

function Player:stringQuestProgress(quest)
    local string = ' ' 

    for i, flag in pairs(quest.flags) do
        if i > 1 then
            string = string .. ', '
        end
        string = string .. flag.flag .. ' (' .. flag.counter .. ' remaining)'
    end
    string = string .. '.'

    return string
end

function Player:getInventorySelections(fun, shop)
    local selectionList = {}

    for i, slot in ipairs(self.items) do
        local displayText = ITEM_DEFS[slot.name].displayName .. slot:getQuantityText()
        if shop ~= nil then
            displayText = displayText .. ' . . . ($' .. tostring(math.max(0, ITEM_DEFS[slot.name].price.sell + shop.sellDiff)) .. ')'
        end
        table.insert(selectionList, Selection(slot.name, fun, i, displayText))
    end

    table.insert(selectionList, Selection('Close', function() gStateStack:pop() end))

    return selectionList
end

function Player:updateInventory()
    for i, item in pairs(self.items) do
        if item.quantity <= 0 then
            table.remove(self.items, i)
        end
    end
end

function Player:sell(index, shop, menu)
    local item = self.items[index]

    if not item.stackable then
        gStateStack:push(ConfirmState(MENU_DEFS['confirm'], {
            onConfirm = function() 
                self.money = self.money + math.max(ITEM_DEFS[item.name].price.sell + shop.sellDiff, 0)
                table.remove(self.items, index)
                gStateStack:pop()
                print(tostring(#self.items))
                menu.selections = self:getInventorySelections(
                    function(subMenuState, otherMenu)
                        gStateStack:push(MenuState(MENU_DEFS['shop_sell_item'], {parent = {shop = subMenuState, menu = otherMenu}}))
                    end,
                    shop
                )
            end
        }))
    else
        self.money = self.money + math.max(item.price.sell + shop.sellDiff, 0)
        item.quantity = item.quantity - 1
        if item.quantity == 0 then
            table.remove(self.items, index)
            gStateStack:pop()
            menu.selections = self:getInventorySelections(
                function(subMenuState, otherMenu)
                    gStateStack:push(MenuState(MENU_DEFS['shop_sell_item'], {parent = {shop = subMenuState, menu = otherMenu}}))
                end,
                shop
            )
        end
    end
end
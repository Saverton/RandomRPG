--[[
    Player Class: defines behavior of the player that the user controls.
    attributes: x, y, width, height, onDeath()
]]

Player = Class{__includes = Entity}

function Player:init(def, level, pos, off)
    Entity.init(self, def, level, pos, off)

    self.pickupRange = 16

    self.money = 0

    self.hotbar = self:getHotbar(3)

    self.hpBar = ProgressBar(PLAYER_BAR_X, PLAYER_HP_BAR_Y, PLAYER_BAR_WIDTH, PLAYER_BAR_HEIGHT, {1, 0, 0, 1})
    self.magicBar = ProgressBar(PLAYER_BAR_X, PLAYER_MAGIC_BAR_Y, PLAYER_BAR_WIDTH, PLAYER_BAR_HEIGHT, {0, 0, 1, 1})
end

function Player:update(dt)
    Entity.update(self, dt)

    -- navigate between held items
    local yScroll = GetYScroll()
    if yScroll ~= 0 then
        self:translateHeldItem(yScroll) 
    end

    -- if space is pressed, launch a sword.
    if self.canUseItem and love.keyboard.wasPressed('space') then
        self:useHeldItem()
    end

    --check for death
    if self.currenthp <= 0 then
        self:onDeath()
        gStateStack:pop()
        gStateStack:push(GameOverState())
    end
end

function Player:render(camera)
    Entity.render(self, camera)
    -- debug: render player bounds
    -- love.graphics.rectangle('line', self.x - camera.x, self.y - camera.y, PLAYER_WIDTH, PLAYER_HEIGHT

    self:renderGui()
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
end

function Player:translateHeldItem(amount)
    love.audio.stop(gSounds['menu_blip_1'])
    love.audio.play(gSounds['menu_blip_1'])
    self.heldItem = (((self.heldItem - 1) - amount) % (#self.hotbar) + 1)
    print('held item: ' .. tostring(self.heldItem))
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
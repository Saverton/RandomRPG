--[[
    Player Class: defines behavior of the player that the user controls.
    attributes: x, y, width, height, onDeath()
]]

Player = Class{__includes = Entity}

function Player:init(def, level, pos, off)
    Entity.init(self, def, level, pos, off)

    self.ItemPanel = Panel(10, 10, 20, 20)

    self.pickupRange = 16
end

function Player:render(camera)
    Entity.render(self, camera)
    -- debug: render player bounds
    -- love.graphics.rectangle('line', self.x - camera.x, self.y - camera.y, PLAYER_WIDTH, PLAYER_HEIGHT

    --render Item Panel
    local item = self.items[self.heldItem]
    self.ItemPanel:render()
    if item ~= nil and #self.items ~= 0 then
        item:render(12, 12)
    end

    -- render ammo count
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print('Ammo: ' .. tostring(self.ammo), AMMO_TEXT_POS_X + 1, AMMO_TEXT_POS_Y + 1)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Ammo: ' .. tostring(self.ammo), AMMO_TEXT_POS_X, AMMO_TEXT_POS_Y)
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

function Player:translateHeldItem(amount)
    self.heldItem = (((self.heldItem - 1) + amount) % (#self.items) + 1)
end
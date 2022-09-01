--[[
    Player Class: defines behavior of the player that the user controls.
    attributes: x, y, width, height, onDeath()
]]

Player = Class{__includes = Entity}

function Player:init(def, level, pos, off)
    Entity.init(self, def, level, pos, off)

    self.ItemPanel = Panel(10, 10, 20, 20)
end

function Player:render(camera)
    Entity.render(self, camera, PLAYER_X_OFFSET, PLAYER_Y_OFFSET)
    -- debug: render player bounds
    -- love.graphics.rectangle('line', self.x - camera.x, self.y - camera.y, PLAYER_WIDTH, PLAYER_HEIGHT

    --render Item Panel
    local item = self.items[self.heldItem]
    self.ItemPanel:render()
    if item ~= nil then
        item:render(12, 12)
    end
end

function Player:update(dt)
    Entity.update(self, dt)

    -- navigate between held items
    self:translateHeldItem(GetYScroll())

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
    self.heldItem = (((self.heldItem - 1) + amount) % #self.items) + 1
end
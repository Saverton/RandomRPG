--[[
    Inventory State: When the player is viewing his inventory.
    @author Saverton
]]

InventoryState = Class{__includes = MenuState}

function InventoryState:init(def, player)
    self.menu = OrderMenu(def, player:getInventory())

    self.player = player
end

function InventoryState:update(dt)
    MenuState.update(self, dt) 
    if love.keyboard.wasPressed('escape') then
        gStateStack:pop()
    end
end

function InventoryState:exit()
    self.player:sortInventory(self.menu:getOrderChange())
end
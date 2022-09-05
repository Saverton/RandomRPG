--[[
    Inventory State: When the player is viewing his inventory.
    @author Saverton
]]

InventoryState = Class{__includes = MenuState}

function InventoryState:init(def, player)
    self.player = player

    MenuState.init(self, def, {selections = self.player:getInventorySelections(
        function() gStateStack:push(MenuState(MENU_DEFS['inventory_item'], {parent = self})) end
    )})
end

function InventoryState:updateInventory()
    self.player:sortInventory(self.menu.selections)
    for i, slot in ipairs(self.menu.selections) do
        slot.oldIndex = i
    end
end

function InventoryState:exit()
    self.player:sortInventory(self.menu.selections)
end
--[[
    Inventory State: When the player is viewing his inventory.
    @author Saverton
]]

InventoryState = Class{__includes = MenuState}

function InventoryState:init(def, player)
    self.player = player

    local selectionList = {}
    local fun = function() gStateStack:push(MenuState(MENU_DEFS['inventory_item'], {parent = self, x = 5})) end

    for i, slot in ipairs(self.player.items) do
        table.insert(selectionList, Selection(slot.name, fun, i, ITEM_DEFS[slot.name].displayName .. slot:getQuantityText()))
    end
    MenuState.init(self, def, {selections = selectionList})
end

function InventoryState:exit()
    self.player:sortInventory(self.menu.selections)
end
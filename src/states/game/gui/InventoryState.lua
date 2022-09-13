--[[
    Inventory State: When the player is viewing his inventory.
    @author Saverton
]]

InventoryState = Class{__includes = MenuState}

function InventoryState:init(definitions, player)
    self.player = player -- reference to the inventory of <player>
    MenuState.init(self, definitions, {selections = self.player:getInventorySelections(
        function() gStateStack:push(MenuState(MENU_DEFS['inventory_item'], {parent = self})) end
    )}) -- call a menu state with the inventory item menu
end

-- update the player's inventory indexes to match any switches
function InventoryState:updateInventory()
    self.player:sortInventory(self.menu.selections) -- sort the player's inventory to match the order of the menu
    for i, selection in ipairs(self.menu.selections) do
        selection.oldIndex = i -- set new old indexes
    end
end

-- sort the player's inventory on close
function InventoryState:exit()
    self.player:sortInventory(self.menu.selections)
end
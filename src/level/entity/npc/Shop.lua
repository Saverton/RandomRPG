--[[
    Shop Class: Shop class is a type of inventory held by an npc. Has items with prices that can be bought and also is capable of allowing
        the player to sell items.
    @author Saverton
]]

Shop = Class{}

function Shop:init(definitions, npc)
    self.npc = npc -- reference to shop owner
    self.text = {
        start = definitions.text.start or 'Hello, welcome to my shop.', -- when player opens shop
        finish = definitions.text.finish or 'Thank you for shopping, goodbye.', -- when player leaves shop
        soldOut = definitions.text.soldOut or 'Sorry, we\'re out of that.', -- when shop is sold out of an item
        notEnough = definitions.text.notEnough or 'Sorry, you can\'t afford that.' -- when player doesn't have enough money
    }
    self:generateInventory(definitions) -- get the shop's inventory
    self.sellDifference = definitions.sellDifference or math.random(-2, 2) -- price differing from market sale price that applies to selling prices from player
end

-- generate the inventory of the shop
function Shop:generateInventory(definitions)
    local itemPool = definitions.itemPool or {} -- the items that can appear in the shop
    self.shopSize = definitions.size or math.min(3, #itemPool) -- the amount of different items sold
    self.inventory = {} -- empty shop inventory to begin
    if definitions.inventory ~= nil then
        self.inventory = definitions.inventory -- if an inventory is defined on loading, set that as inventory
    else -- generate items in the shop
        local indexesUsed = {} -- list of indexes of items already in the shop within the item pool
        for i = 1, self.shopSize, 1 do
            local index = math.random(1, #itemPool) -- choose a random item index
            while Contains(indexesUsed, index) do
                index = math.random(1, #itemPool) -- if already in shop, try again
            end
            local quantity = 1 -- set quantity to 1 by default
            if ITEM_DEFS[itemPool[index]].stackable then
                quantity = math.random(3, 8) -- if it is stackable, can have larger inventory
            end
            local item = {
                name = itemPool[index], -- name of the actual item
                price = math.max(1, ITEM_DEFS[itemPool[index]].price.buy + math.random(-2, 2)), -- market price of the item with a randomized variation
                quantity = quantity
            }
            table.insert(self.inventory, item) 
            table.insert(indexesUsed, index) -- insert this index into the list of used indexes from the item pool
        end
    end
end

-- called when interacted with, sets player reference to the opening entity, pushes the start dialogue and the main shop menu
function Shop:open(player)
    self.player = player -- set player reference to interacting entity
    gStateStack:push(DialogueState(self.startText, self.npc.animator.texture, 1, function() gStateStack:push(
        MenuState(MENU_DEFS['shop_main'], {parent = self})) end))
end

-- close the shop, sets player reference back to nil
function Shop:close()
    self.player = nil
end

-- get a list of selection objects according to the shop's inventory, function call opens the buy item menu
function Shop:getSelections()
    local selections = {}
    for i, item in ipairs(self.inventory) do
        table.insert(selections, Selection(
            item.name, -- name of the item in the shop
            function(menu) gStateStack:push(MenuState(MENU_DEFS['shop_buy_item'], {parent = {shop = self, menu = menu}})) end, -- open buy item menu
            ITEM_DEFS[item.name].displayName .. ' . . . ($' .. tostring(item.price) .. ')' .. ' . . . (' .. tostring(item.quantity) .. ')'
                -- display item followed by price followed by quantity available
        ))
    end
    table.insert(selections, Selection('close', function() gStateStack:pop() end)) -- add close option
    return selections
end

-- try to execute a purchase at the specified index
function Shop:tryTransaction(index)
    local item = self.inventory[index] -- reference to the selected item
    if item.quantity > 0 then
        if self.player.money >= item.price then -- make sure player has enough money
            if not ITEM_DEFS[item.name].stackable then
                gStateStack:push(ConfirmState(MENU_DEFS['confirm'], {
                    onConfirm = function() self:transaction(item) end
                })) -- check for confirmation on non-stackable items, since they are more expensive and aren't bought in bulk
            else
                self:transaction(item)
            end
        else
            gStateStack:push(DialogueState(self.text.notEnough, self.npc.animator.texture, 1)) -- show not enough text
        end
    else
        gStateStack:push(DialogueState(self.text.soldOut, self.npc.animator.texture, 1)) -- show item sold out text
    end
end

-- actually execute the transaction itself
function Shop:transaction(item)
    gSounds['gui']['shop_exchange']:play() -- play transaction sound
    self.player.money = math.max(0, self.player.money - item.price) -- update player money
    self.player:giveItem(Item(item.name, self.player, 1)) -- give the player the purchased item
    item.quantity = math.max(0, item.quantity - 1) -- update shop quantity
end

-- return the number of items for sale in the shop
function Shop:getNumberOfItems()
    local total = 0
    for i, item in pairs(self.inventory) do
        total = total + item.quantity -- add the quantity of item to total number
    end
    return total
end

-- create a selection list for items that the player can sell
function Shop:getPlayerInventorySelections(onSelectFunction)
    local selections = self.player:getInventorySelections(onSelectFunction) -- get a list of selections for item inventory
    for i, selection in ipairs(selections) do -- add a price onto each selection
        selection.displayText = selection.displayText .. ' . . . ($' .. tostring(math.max(0, ITEM_DEFS[selection.name].price.sell + self.sellDifference)) .. ')'
    end
    return selections
end

-- return a table with save data for a shop
function Shop:getSaveData()
    return {text = self.text, sellDifference = self.sellDifference, inventory = self.inventory} -- table of save data
end
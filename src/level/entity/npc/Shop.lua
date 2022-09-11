--[[
    Shop Class: a shop which can be held by an NPC.
    @author Saverton
]]

Shop = Class{}

function Shop:init(def, npc)
    self.npc = npc
    self.player = nil

    self.startText = def.startText or 'Hello, welcome to my shop.'
    self.endText = def.endText or 'Thank you for shopping, goodbye.'
    self.soldOutText = def.soldOutText or 'Sorry, we\'re out of that.'
    self.notEnoughText = def.notEnoughText or 'Sorry, you can\'t afford that.'
    -- generate the shop items
    local itemPool = def.itemPool or {}
    self.shopSize = def.size or math.min(3, #itemPool)
    self.inventory = {}
    if def.inventory ~= nil then
        self.inventory = def.inventory
    else
        local indexesUsed = {}
        for i = 1, self.shopSize, 1 do
            local id = math.random(1, #itemPool)
            while Contains(indexesUsed, id) do
                id = math.random(1, #itemPool)
            end
            local quantity = 1
            if ITEM_DEFS[itemPool[id]].stackable then
                quantity = math.random(3, 10)
            end
            local item = {
                name = itemPool[id],
                price = math.max(1, ITEM_DEFS[itemPool[id]].price.buy + math.random(-2, 2)),
                quantity = quantity
            }
            table.insert(self.inventory, item) 
            table.insert(indexesUsed, id)
        end
    end

    -- price differing from market sale price that the shop buys things with
    self.sellDiff = def.sellDiff or math.random(-2, 2)
end

function Shop:open(player)
    self.player = player
    gStateStack:push(DialogueState(self.startText, self.npc.animator.texture, 1, function() gStateStack:push(
        MenuState(MENU_DEFS['shop_main'], {parent = self})) end))
end

function Shop:close()
    self.player = nil
end

function Shop:getSelections()
    local selections = {}

    for i, item in ipairs(self.inventory) do
        table.insert(selections, Selection(
            item.name,
            function(menu)
                gStateStack:push(MenuState(MENU_DEFS['shop_buy_item'], {parent = {shop = self, menu = menu}}))
            end,
            0,
            ITEM_DEFS[item.name].displayName .. ' . . . ($' .. tostring(item.price) .. ')' .. ' . . . (' .. tostring(item.quantity) .. ')'
        ))
    end

    table.insert(selections, Selection(
        'close', function() 
            gStateStack:pop()
        end
    ))

    return selections
end

function Shop:transaction(index)
    local item = self.inventory[index]

    if item.quantity > 0 then
        if self.player.money >= item.price then
            --buy item
            if not ITEM_DEFS[item.name].stackable then
                gStateStack:push(ConfirmState(MENU_DEFS['confirm'], {
                    onConfirm = function() 
                        gSounds['gui']['shop_exchange']:play()
                        self.player.money = math.max(0, self.player.money - item.price)
                        self.player:getItem(Item(item.name, self.player, 1))
                        item.quantity = math.max(0, item.quantity - 1)
                    end
                }))
            else
                gSounds['gui']['shop_exchange']:play()
                self.player.money = math.max(0, self.player.money)
                self.player:getItem(Item(item.name, self.player, 1))
                item.quantity = math.max(0, item.quantity - 1)
            end
        else
            gStateStack:push(DialogueState(self.notEnoughText, self.npc.animator.texture, 1))
        end
    else
        gStateStack:push(DialogueState(self.soldOutText, self.npc.animator.texture, 1))
    end
end

function Shop:getNumItems()
    local num = 0

    for i, item in pairs(self.inventory) do
        num = num + item.quantity
    end

    return num
end
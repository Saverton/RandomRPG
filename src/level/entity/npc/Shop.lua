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

function Shop:open(player)
    self.player = player
    gStateStack:push(
        MenuState(
            MENU_DEFS['shop'],
            {
                selections = self:getSelections(),
                parent = self
            }
        )
    )
    gStateStack:push(DialogueState(self.startText, self.npc.animations['idle-down'].texture, 1))
end

function Shop:close()
    self.player = nil
end

function Shop:getSelections()
    local selections = {}

    for i, item in ipairs(self.inventory) do
        table.insert(selections, Selection(
            ITEM_DEFS[item.name],
            function()
                if item.quantity > 0 then
                    if self.player.money >= item.price then
                        self.player.money = self.player.money - item.price
                        self.player:getItem(Item(item.name, self.player, 1))
                        item.quantity = math.max(0, item.quantity - 1)
                        if item.quantity == 0 then
                            table.remove(self.inventory, i)
                        end
                    else
                        gStateStack:push(DialogueState(self.notEnoughText, self.npc.animations['idle-down'].texture, 1))
                    end
                else
                    gStateStack:push(DialogueState(self.soldOutText, self.npc.animations['idle-down'].texture, 1))
                end
            end,
            0,
            ITEM_DEFS[item.name].displayName .. ' . . . ($' .. tostring(item.price) .. ')' .. ' . . . (' .. tostring(item.quantity) .. ')'
        ))
    end

    table.insert(selections, Selection(
        'close', function() 
            gStateStack:pop()
            gStateStack:push(DialogueState(self.endText, self.npc.animations['idle-down'].texture, 1))
        end
    ))

    return selections
end

function Shop:getNumItems()
    local num = 0

    for i, item in pairs(self.inventory) do
        num = num + item.quantity
    end

    return num
end
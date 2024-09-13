--[[
    Definitions for all menus that are static in the game.
    @author Saverton
]]

MENU_DEFS = {
    ['start'] = {
        x = VIRTUAL_WIDTH / 2 - 50,
        y = 100,
        width = 100,
        height = 100,
        title = 'Options',
        subtitle = '',
        selections = {
            Selection('Play', function() gStateStack:push(MenuState(Menu(MENU_DEFS['play']), {})) end),
            Selection('Debug', function() gStateStack:push(WorldState({debug = true})) end),
            Selection('Exit', function() love.event.quit() end)
        }
    },
    ['play'] = {
        x = VIRTUAL_WIDTH / 2 - 50,
        y = 100,
        width = 100,
        height = 100,
        title = 'Play',
        subtitle = '',
        selections = {
            Selection('New Game', function()
                gStateStack:pop()
                gStateStack:push(CreateWorldState())
            end),
            Selection('Load Game', function() gStateStack:push(MenuState(MENU_DEFS['choose_world'], {
                selections = LoadWorldList()
            })) end),
            Selection('Back', function() gStateStack:pop() end)
        }
    },
    ['choose_world'] = {
        x = VIRTUAL_WIDTH / 2 - 50,
        y = 100,
        width = 100,
        height = 100,
        title = 'Choose World',
        subtitle = '',
        selections = {}
    },
    ['pause'] = {
        x = MENU_X,
        y = MENU_Y,
        width = MENU_WIDTH,
        height = MENU_HEIGHT,
        title = 'Pause',
        subtitle = '',
        shiftIn = true,
        selections = {
            Selection('Resume', function() gStateStack:pop() end),
            Selection('Save Game', function(level) 
                gStateStack:push(SaveState(level)) 
            end),
            Selection('Exit to Title', function() 
                gStateStack:push(ConfirmState(MENU_DEFS['confirm'], {
                    onConfirm = function() 
                        gStateStack:pop()
                        gStateStack:pop()
                    end
                }))
            end)
        }
    },
    ['inventory'] = {
        x = MENU_X,
        y = MENU_Y,
        width = MENU_WIDTH,
        height = MENU_HEIGHT,
        title = 'Inventory',
        subtitle = 'Select an Item',
        selections = {}
    },
    ['inventory_item'] = {
        x = MENU_X + MENU_WIDTH + 5,
        y = MENU_Y + MENU_HEIGHT / 2,
        width = 50,
        height = 100,
        title = 'Item',
        subtitle = '',
        selections = {
            Selection('About', function(menuState) 
                local item = ITEM_DEFS[menuState.menu.selections[menuState.menu.selectors[menuState.menu.selector].position].name]
                gStateStack:push(DialogueState(item.displayName .. ': ' .. item.description, item.texture, item.frame)) 
            end),
            Selection('Switch', function(menuState)
                table.insert(menuState.menu.selectors, {position = 1, selected = false, text = 'select item to switch', maxIndex = #menuState.menu.selections - 1,
                    onChoose = function() 
                        menuState.menu:switch(menuState.menu.selectors[1].position, menuState.menu.selectors[2].position) 
                        menuState:updateInventory()
                        table.remove(menuState.menu.selectors, 2)
                        menuState.menu.selector = 1
                    end}
                )
                menuState.menu.selector = 2
                gStateStack:pop()
            end),
            Selection('Delete', function(menuState) 
                gStateStack:push(ConfirmState(MENU_DEFS['confirm'], {
                    onConfirm = function() 
                        table.remove(menuState.menu.selections, menuState.menu.selectors[menuState.menu.selector].position)
                        menuState:updateInventory()
                        gStateStack:pop()
                    end
                }))
            end),
            Selection('Back', function() gStateStack:pop() end)
        }
    },
    --[[ ['quest'] = {
        x = MENU_X,
        y = MENU_Y,
        width = MENU_WIDTH,
        height = MENU_HEIGHT,
        title = 'Quests',
        subtitle = '',
        selections = {}
    },
    ['quest_item'] = {
        x = MENU_X + MENU_WIDTH + 5,
        y = MENU_Y + MENU_HEIGHT / 2,
        width = 75,
        height = 100,
        title = 'Quest',
        subtitle = '',
        selections = {
            Selection('Info', function(menuState)
                local menu = menuState.menu
                local questManager = menuState.player.questManager
                local playerQuest = questManager.quests[GetIndex(questManager.quests, menu.selections[menu.selectors[menu.selector].position].name)]
                local quest = playerQuest.questRef
                gStateStack:push(DialogueState(quest.quest.name .. ' Progress: ' .. questManager:getProgressString(playerQuest) .. '\nRewards: ' .. quest:getRewardString())) 
            end),
            Selection('Abandon', function(menuState) 
                gStateStack:push(ConfirmState(MENU_DEFS['confirm'], {
                    onConfirm = function()
                        local menu = menuState.menu
                        local quest = menuState.player.questManager.quests[GetIndex(menuState.player.questManager.quests, menu.selections[menu.selectors[menu.selector].position].name)]
                        table.remove(menuState.player.questManager.quests, GetIndex(menuState.player.questManager.quests, quest.name))
                        table.remove(menu.selections, menu.selectors[menu.selector].position)
                        gStateStack:pop()
                    end
                }))
            end),
            Selection('Back', function() gStateStack:pop() end)
        }
    }, ]]
    ['confirm'] = {
        x = VIRTUAL_WIDTH / 2 - 40,
        y = VIRTUAL_HEIGHT / 2 - 40,
        width = 80,
        height = 80,
        title = 'Confirm?',
        subtitle = '',
        selections = {
            Selection('Yes', function(menuState) 
                gStateStack:pop()
                menuState.onConfirm()
            end),
            Selection('No', function(menuState)
                gStateStack:pop()
                menuState.onDeny()
            end)
        }
    },
    --[[ ['quest_confirm'] = {
        x = VIRTUAL_WIDTH / 2 - 40,
        y = VIRTUAL_HEIGHT / 2 - 40,
        width = 80,
        height = 80,
        title = 'Accept?',
        subtitle = 'Accept this quest?',
        selections = {
            Selection('Yes', function(menuState) 
                gStateStack:pop()
                menuState.onConfirm()
            end),
            Selection('No', function(menuState)
                gStateStack:pop()
                menuState.onDeny()
            end)
        }
    }, ]]
    ['shop_main'] = {
        x = VIRTUAL_WIDTH / 2 - 40,
        y = MENU_Y + 20,
        width = 80,
        height = MENU_HEIGHT / 2 - 5,
        title = 'Shop',
        subtitle = '',
        selections = {
            Selection('Buy', function(menuState)
                gStateStack:push(MenuState(MENU_DEFS['shop_buy'], {parent = menuState, 
                    selections = menuState:getSelections()}))
            end),
            Selection('Sell', function(menuState)
                local player = menuState.player
                gStateStack:push(MenuState(MENU_DEFS['shop_sell'], {parent = menuState, 
                    selections = menuState:getPlayerInventorySelections(
                        function(subMenuState, menu)
                            gStateStack:push(MenuState(MENU_DEFS['shop_sell_item'], {parent = {shop = subMenuState, menu = menu}}))
                        end
                    )}))
            end),
            Selection('Leave', function(menuState)
                gStateStack:pop()
                gStateStack:push(DialogueState(menuState.text.finish, menuState.npc.animator.texture, 1))
            end)
        }
    },
    ['shop_buy'] = {
        x = MENU_X,
        y = MENU_Y,
        width = MENU_WIDTH,
        height = MENU_HEIGHT,
        title = 'Shop',
        subtitle = '',
        selectors = {
            {position = 1, selected = false, text = 'Pick an item',
                onChoose = function(position, menu)
                    menu.selections[position].onSelect(menu)
                end
            }
        }
    },
    ['shop_sell'] = {
        x = MENU_X,
        y = MENU_Y,
        width = MENU_WIDTH,
        height = MENU_HEIGHT,
        title = 'Shop',
        subtitle = 'pick an item to sell',
        selectors = {
            {position = 1, selected = false,
                onChoose = function(position, menu)
                    menu.selections[position].onSelect(menu.parent, menu)
                end
            }
        }
    },
    ['shop_buy_item'] = {
        x = MENU_X + MENU_WIDTH + 5,
        y = MENU_Y + MENU_HEIGHT / 2,
        width = 75,
        height = 100,
        title = 'Item',
        subtitle = '',
        selections = {
            Selection('Buy', function(menuState)
                local menu = menuState.menu
                local shop = menuState.shop
                print(#shop.inventory)
                shop:tryTransaction(GetIndex(shop.inventory, menu.selections[menu.selectors[menu.selector].position].name))
                menu.selections = shop:getSelections()
            end),
            Selection('About', function(menuState) 
                local menu = menuState.menu
                local item = ITEM_DEFS[menu.selections[menu.selectors[menu.selector].position].name]
                    gStateStack:push(DialogueState(item.displayName .. ': ' .. item.description, item.texture, item.frame)) 
            end),
            Selection('Back', function(menuState) gStateStack:pop() end)
        }
    },
    ['shop_sell_item'] = {
        x = MENU_X + MENU_WIDTH + 5,
        y = MENU_Y + MENU_HEIGHT / 2,
        width = 75,
        height = 100,
        title = 'Item',
        subtitle = '',
        selections = {
            Selection('Sell', function(menuState)
                local player = menuState.shop.player
                local menu = menuState.menu
                player:sell(GetIndex(player.items, menu.selections[menu.selectors[menu.selector].position].name), menuState.shop, menu)
            end),
            Selection('About', function(menuState) 
                local menu = menuState.menu
                local item = ITEM_DEFS[menu.selections[menu.selectors[menu.selector].position].name]
                    gStateStack:push(DialogueState(item.displayName .. ': ' .. item.description .. '\nSale Price: $' .. 
                        tostring(math.max(item.price.sell + menuState.shop.sellDifference, 0)), item.texture, item.frame)) 
            end),
            Selection('Back', function(menuState) gStateStack:pop() end)
        }
    },
    ['level_up'] = {
        x = VIRTUAL_WIDTH / 2 - 40,
        y = MENU_Y + 20,
        width = 80,
        height = MENU_HEIGHT / 2 - 5,
        title = 'Level Up',
        subtitle = 'choose stat to upgrade:',
        selections = {},
        shiftIn = true
    }
}

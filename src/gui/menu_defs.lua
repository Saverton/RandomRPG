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
        selections = {
            Selection('Play', function() gStateStack:push(WorldState({debug = false})) end),
            Selection('Debug', function() gStateStack:push(WorldState({debug = true})) end),
            Selection('Exit', function() love.event.quit() end)
        }
    },
    ['pause'] = {
        x = MENU_X,
        y = MENU_Y,
        width = MENU_WIDTH,
        height = MENU_HEIGHT,
        title = 'Pause',
        selections = {
            Selection('Resume', function() gStateStack:pop() end),
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
        selections = {},
        selectors = {{pos = 1, selected = false, text = '\'esc\' to exit', 
            onChoose = function(pos, menu) menu.selections[pos].onSelect(menu.parent) end}}
    },
    ['inventory_item'] = {
        x = MENU_X + MENU_WIDTH + 5,
        y = MENU_Y + MENU_HEIGHT / 2,
        width = 50,
        height = 100,
        title = 'Item',
        selections = {
            Selection('About', function(menuState) 
                local item = ITEM_DEFS[menuState.menu.selections[menuState.menu.selectors[menuState.menu.selector].pos].name]
                gStateStack:push(DialogueState(item.displayName .. ': ' .. item.description, item.texture, item.frame)) 
            end),
            Selection('Switch', function(menuState)
                table.insert(menuState.menu.selectors, {pos = 1, selected = false, text = 'select item to switch', 
                    onChoose = function() 
                        menuState.menu:switch(menuState.menu.selectors[1].pos, menuState.menu.selectors[2].pos) 
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
                        table.remove(menuState.menu.selections, menuState.menu.selectors[menuState.menu.selector].pos)
                        menuState:updateInventory()
                        gStateStack:pop()
                    end
                }))
            end),
            Selection('Back', function() gStateStack:pop() end)
        }
    },
    ['shop'] = {
        x = MENU_X,
        y = MENU_Y,
        width = MENU_WIDTH,
        height = MENU_HEIGHT,
        title = 'Shop',
        selectors = {
            {pos = 1, selected = false, text = 'Pick an item to purchase',
                onChoose = function(pos, menu)
                    menu.selections[pos].onSelect()
                    menu.selections = menu.parent:getSelections()
                end
            }
        }
    },
    ['quest'] = {
        x = MENU_X,
        y = MENU_Y,
        width = MENU_WIDTH,
        height = MENU_HEIGHT,
        title = 'Quests',
        selections = {},
        selectors = {{pos = 1, selected = false, text = '\'esc\' to exit', 
            onChoose = function(pos, menu) menu.selections[pos].onSelect(menu.parent) end}}
    },
    ['quest_item'] = {
        x = MENU_X + MENU_WIDTH + 5,
        y = MENU_Y + MENU_HEIGHT / 2,
        width = 75,
        height = 100,
        title = 'Quest',
        selections = {
            Selection('Info', function(menuState) 
                local menu = menuState.menu
                local playerQuest = menuState.player.quests[GetIndex(menuState.player.quests, menu.selections[menu.selectors[menu.selector].pos].name)]
                local quest = playerQuest.questRef
                gStateStack:push(DialogueState('Progress: ' .. menuState.player:stringQuestProgress(playerQuest)))
                gStateStack:push(DialogueState(quest.quest.name .. ': ' .. quest:stringQuest() .. '\nRewards: ' .. quest:stringReward())) 
            end),
            Selection('Abandon', function(menuState) 
                gStateStack:push(ConfirmState(MENU_DEFS['confirm'], {
                    onConfirm = function() 
                        local menu = menuState.menu
                        local quest = menuState.player.quests[GetIndex(menuState.player.quests, menu.selections[menu.selectors[menu.selector].pos].name)]
                        table.remove(menuState.player.quests, GetIndex(menuState.player.quests, quest.name))
                        table.remove(menu.selections, menu.selectors[menu.selector].pos)
                        gStateStack:pop()
                    end
                }))
            end),
            Selection('Back', function() gStateStack:pop() end)
        }
    },
    ['confirm'] = {
        x = VIRTUAL_WIDTH / 2 - 40,
        y = VIRTUAL_HEIGHT / 2 - 40,
        width = 80,
        height = 80,
        title = 'Confirm?',
        selections = {
            Selection('Yes', function(menuState) 
                gStateStack:pop()
                menuState.onConfirm()
            end),
            Selection('No', function(menuState)
                gStateStack:pop()
                menuState.onDeny()
            end)
        },
        selectors = {{pos = 1, selected = false, text = '\'esc\' = No', 
            onChoose = function(pos, menu) menu.selections[pos].onSelect(menu.parent) end}}
    },
    ['quest_confirm'] = {
        x = VIRTUAL_WIDTH / 2 - 40,
        y = VIRTUAL_HEIGHT / 2 - 40,
        width = 80,
        height = 80,
        title = 'Accept?',
        selections = {
            Selection('Yes', function(menuState) 
                gStateStack:pop()
                menuState.onConfirm()
            end),
            Selection('No', function(menuState)
                gStateStack:pop()
                menuState.onDeny()
            end)
        },
        selectors = {{pos = 1, selected = false, text = 'Accept this quest?', 
            onChoose = function(pos, menu) menu.selections[pos].onSelect(menu.parent) end}}
    }
}
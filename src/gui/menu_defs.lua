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
                gStateStack:pop()
                gStateStack:pop()
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
        selectors = {{pos = 1, selected = false, text = '\'esc\' to exit', onChoose = function(pos, menu) menu.selections[pos].onSelect(menu.parent) end}}
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
                table.remove(menuState.menu.selections, menuState.menu.selectors[menuState.menu.selector].pos)
                menuState:updateInventory()
                gStateStack:pop()
            end),
            Selection('Back', function() gStateStack:pop() end)
        }
    }
}
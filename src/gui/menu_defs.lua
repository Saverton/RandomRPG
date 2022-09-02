--[[
    Definitions for all menus that are static in the game.
    @author Saverton
]]

MENU_DEFS = {
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
    }
}
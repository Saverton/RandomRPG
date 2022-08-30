--[[
    Definitions for all world features in the game.
    @author Saverton
]]

FEATURE_DEFS = {
    ['empty'] = {
        id = 0,
        name = 'empty',
        texture = 'empty',
        frame = 0,
        onInteract = function() end,
        isSolid = false
    },
    ['tree'] = {
        id = 1,
        name = 'tree',
        texture = 'features',
        frame = 1,
        onInteract = function() end,
        isSolid = false
    },
    ['rock'] = {
        id = 2,
        name = 'rock',
        texture = 'features',
        frame = 2,
        onInteract = function() end,
        isSolid = true
    }
}
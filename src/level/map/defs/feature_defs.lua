--[[
    Definitions for all world features in the game.
    @author Saverton
]]

FEATURE_DEFS = {
    ['tree'] = {
        id = 1,
        name = 'tree',
        texture = 'features',
        frame = 1,
        onInteract = function() end
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
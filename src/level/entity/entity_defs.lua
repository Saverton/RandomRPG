--[[
    Table defining attributes for all entities.
    @author Saverton
]]

ENTITY_DEFS = {
    ['player'] = {
        width = PLAYER_WIDTH,
        height = PLAYER_HEIGHT,
        stateMachine = {
            ['idle'] = function() return PlayerIdleState() end,
            ['walk'] = function() return PlayerWalkState() end
        },
        animations = {
            ['idle-right'] = {
                texture = gTextures['player'],
                frames = {1}
            },
            ['idle-down'] = {
                texture = gTextures['player'],
                frames = {5}
            },
            ['idle-left'] = {
                texture = gTextures['player'],
                frames = {1},
                xScale = -1
            },
            ['idle-up'] = {
                texture = gTextures['player'],
                frames = {9}
            },
            ['walk-right'] = {
                texture = gTextures['player'],
                frames = {1, 2, 3, 4},
                speed = PLAYER_ANIMATION_SPEED
            },
            ['walk-down'] = {
                texture = gTextures['player'],
                frames = {5, 6, 7, 8},
                speed = PLAYER_ANIMATION_SPEED
            },
            ['walk-left'] = {
                texture = gTextures['player'],
                frames = {1, 2, 3, 4},
                speed = PLAYER_ANIMATION_SPEED,
                xScale = -1
            },
            ['walk-up'] = {
                texture = gTextures['player'],
                frames = {9, 10, 11, 12},
                speed = PLAYER_ANIMATION_SPEED
            }
        }
    }
}
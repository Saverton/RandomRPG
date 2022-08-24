--[[
    Table defining attributes for all entities.
    @author Saverton
]]

ENTITY_DEFS = {
    ['player'] = {
        width = PLAYER_WIDTH,
        height = PLAYER_HEIGHT,
        animations = {
            ['idle-right'] = {
                texture = 'player',
                frames = {1}
            },
            ['idle-down'] = {
                texture = 'player',
                frames = {5}
            },
            ['idle-left'] = {
                texture = 'player',
                frames = {1},
                xScale = -1
            },
            ['idle-up'] = {
                texture = 'player',
                frames = {9}
            },
            ['walk-right'] = {
                texture = 'player',
                frames = {1, 2, 3, 4},
                interval = PLAYER_ANIMATION_SPEED
            },
            ['walk-down'] = {
                texture = 'player',
                frames = {5, 6, 7, 8},
                interval = PLAYER_ANIMATION_SPEED
            },
            ['walk-left'] = {
                texture = 'player',
                frames = {1, 2, 3, 4},
                interval = PLAYER_ANIMATION_SPEED,
                xScale = -1
            },
            ['walk-up'] = {
                texture = 'player',
                frames = {9, 10, 11, 12},
                interval = PLAYER_ANIMATION_SPEED
            }
        },
        hp = PLAYER_BASE_HP,
        speed = PLAYER_BASE_SPEED,
        defense = PLAYER_BASE_DEFENSE
    }
}
--[[
    Table defining attributes for all entities.
    @author Saverton
]]

ENTITY_DEFS = {
    ['player'] = {
        name = 'player',
        width = PLAYER_WIDTH,
        height = PLAYER_HEIGHT,
        xOffset = PLAYER_X_OFFSET,
        yOffset = PLAYER_Y_OFFSET,
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
            },
            ['interact-up'] = {
                texture = 'player',
                frames = {14},
            },
            ['interact-right'] = {
                texture = 'player',
                frames = {13},
            },
            ['interact-down'] = {
                texture = 'player',
                frames = {15},
            },
            ['interact-left'] = {
                texture = 'player',
                frames = {13},
                xScale = -1
            }
        },
        hp = PLAYER_BASE_HP,
        speed = PLAYER_BASE_SPEED,
        defense = PLAYER_BASE_DEFENSE,
        magic = PLAYER_BASE_MAGIC,
        magicRegenRate = 0.5,
        onDeath = function() love.audio.play(gSounds['player_dies_1']) end,
        push = 16
    },
    ['goblin'] = {
        name = 'goblin',
        width = 12,
        height = 12,
        xOffset = -2,
        yOffset = -4,
        animations = {
            ['idle-right'] = {
                texture = 'goblin',
                frames = {1}
            },
            ['idle-down'] = {
                texture = 'goblin',
                frames = {5}
            },
            ['idle-left'] = {
                texture = 'goblin',
                frames = {1},
                xScale = -1
            },
            ['idle-up'] = {
                texture = 'goblin',
                frames = {9}
            },
            ['walk-right'] = {
                texture = 'goblin',
                frames = {1, 2, 3, 4},
                interval = DEFAULT_ANIMATION_SPEED
            },
            ['walk-down'] = {
                texture = 'goblin',
                frames = {5, 6, 7, 8},
                interval = DEFAULT_ANIMATION_SPEED
            },
            ['walk-left'] = {
                texture = 'goblin',
                frames = {1, 2, 3, 4},
                interval = DEFAULT_ANIMATION_SPEED,
                xScale = -1
            },
            ['walk-up'] = {
                texture = 'goblin',
                frames = {9, 10, 11, 12},
                interval = DEFAULT_ANIMATION_SPEED
            }
        },
        hp = 5,
        speed = 16,
        agroSpeedBoost = 2,
        defense = 1,
        attack = 1,
        agroDist = 7,
        onDeath = function(entity, level) 
            love.audio.play(gSounds['enemy_dies_1'])
            table.insert(level.pickups, Pickup('ammo', entity.x, entity.y, math.random(1, 3)))
        end,
        push = 8
    },
    ['rock_golem'] = {

    }
}
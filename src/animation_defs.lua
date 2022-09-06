--[[
    definitions for all animations in the game.
    @author Saverton
]]

ANIMATION_DEFS = {
    ['player'] = {
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
    ['goblin'] = {
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
    ['skeleton'] = {
        ['idle-right'] = {
            texture = 'skeleton',
            frames = {5}
        },
        ['idle-down'] = {
            texture = 'skeleton',
            frames = {1}
        },
        ['idle-left'] = {
            texture = 'skeleton',
            frames = {5},
            xScale = -1
        },
        ['idle-up'] = {
            texture = 'skeleton',
            frames = {9}
        },
        ['walk-right'] = {
            texture = 'skeleton',
            frames = {5, 6, 5, 7},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-down'] = {
            texture = 'skeleton',
            frames = {1, 2, 1, 3},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-left'] = {
            texture = 'skeleton',
            frames = {5, 6, 5, 7},
            interval = DEFAULT_ANIMATION_SPEED,
            xScale = -1
        },
        ['walk-up'] = {
            texture = 'skeleton',
            frames = {9, 10, 9, 11},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['interact-down'] = {
            texture = 'skeleton',
            frames = {4}
        },
        ['interact-right'] = {
            texture = 'skeleton',
            frames = {8}
        },
        ['interact-up'] = {
            texture = 'skeleton',
            frames = {12}
        },
        ['interact-left'] = {
            texture = 'skeleton',
            frames = {8},
            xScale = -1
        }
    },
    ['npc'] = {
        ['idle-down'] = {
            texture = 'npc',
            frames = {1}
        }, 
        ['idle-right'] = {
            texture = 'npc',
            frames = {4}
        },
        ['idle-up'] = {
            texture = 'npc',
            frames = {7}
        },
        ['idle-left'] = {
            texture = 'npc',
            frames = {10},
            xScale = -1
        },
        ['walk-down'] = {
            texture = 'npc',
            frames = {1, 2, 1, 3},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-right'] = {
            texture = 'npc',
            frames = {4, 5, 4, 6},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-up'] = {
            texture = 'npc',
            frames = {7, 8, 7, 9},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-left'] = {
            texture = 'npc',
            frames = {4, 5, 4, 6},
            interval = DEFAULT_ANIMATION_SPEED,
            xScale = -1
        }
    },
    ['water'] = {
        ['main'] = {
            texture = 'tiles',
            frames = {3, 4},
            interval = 0.5
        }
    },
    ['chest'] = {
        ['main'] = {
            texture = 'features',
            frames = {3},
        },
        ['open'] = {
            texture = 'features',
            frames = {3, 4, 5, 6},
            interval = 0.3,
            looping = false
        }
    }
}
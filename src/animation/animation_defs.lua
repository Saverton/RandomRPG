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
            frames = {4}
        },
        ['idle-left'] = {
            texture = 'player',
            frames = {1},
            xScale = -1
        },
        ['idle-up'] = {
            texture = 'player',
            frames = {7}
        },
        ['walk-right'] = {
            texture = 'player',
            frames = {1, 2, 1, 3},
            interval = PLAYER_ANIMATION_SPEED
        },
        ['walk-down'] = {
            texture = 'player',
            frames = {4, 5, 4, 6},
            interval = PLAYER_ANIMATION_SPEED
        },
        ['walk-left'] = {
            texture = 'player',
            frames = {1, 2, 1, 3},
            interval = PLAYER_ANIMATION_SPEED,
            xScale = -1
        },
        ['walk-up'] = {
            texture = 'player',
            frames = {7, 8, 7, 9},
            interval = PLAYER_ANIMATION_SPEED
        },
        ['interact-up'] = {
            texture = 'player',
            frames = {11},
        },
        ['interact-right'] = {
            texture = 'player',
            frames = {10},
        },
        ['interact-down'] = {
            texture = 'player',
            frames = {12},
        },
        ['interact-left'] = {
            texture = 'player',
            frames = {10},
            xScale = -1
        },
        ['spin'] = {
            texture = 'player',
            frames = {1, 4, 7, 13},
            interval = 0.1
        },
        ['item-get'] = {
            texture = 'player',
            frames = {14}
        }
    },
    ['player_death'] = {
        ['up'] = {
            texture = 'player_death',
            frames = {3}
        },
        ['right'] = {
            texture = 'player_death',
            frames = {1}
        },
        ['down'] = {
            texture = 'player_death',
            frames = {2}
        },
        ['left'] = {
            texture = 'player_death',
            frames = {1},
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
            frames = {4}
        },
        ['idle-left'] = {
            texture = 'goblin',
            frames = {1},
            xScale = -1
        },
        ['idle-up'] = {
            texture = 'goblin',
            frames = {7}
        },
        ['walk-right'] = {
            texture = 'goblin',
            frames = {1, 2, 1, 3},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-down'] = {
            texture = 'goblin',
            frames = {4, 5, 4, 6},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-left'] = {
            texture = 'goblin',
            frames = {1, 2, 1, 3},
            interval = DEFAULT_ANIMATION_SPEED,
            xScale = -1
        },
        ['walk-up'] = {
            texture = 'goblin',
            frames = {7, 8, 7, 9},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['interact-right'] = {
            texture = 'goblin',
            frames = {10}
        },
        ['interact-down'] = {
            texture = 'goblin',
            frames = {12}
        },
        ['interact-left'] = {
            texture = 'goblin',
            frames = {10},
            xScale = -1
        },
        ['interact-up'] = {
            texture = 'goblin',
            frames = {11},
        }
    },
    ['skeleton'] = {
        ['idle-right'] = {
            texture = 'skeleton',
            frames = {4}
        },
        ['idle-down'] = {
            texture = 'skeleton',
            frames = {1}
        },
        ['idle-left'] = {
            texture = 'skeleton',
            frames = {4},
            xScale = -1
        },
        ['idle-up'] = {
            texture = 'skeleton',
            frames = {7}
        },
        ['walk-right'] = {
            texture = 'skeleton',
            frames = {4, 5, 4, 6},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-down'] = {
            texture = 'skeleton',
            frames = {1, 2, 1, 3},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-left'] = {
            texture = 'skeleton',
            frames = {4, 5, 4, 6},
            interval = DEFAULT_ANIMATION_SPEED,
            xScale = -1
        },
        ['walk-up'] = {
            texture = 'skeleton',
            frames = {7, 8, 7, 9},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['interact-down'] = {
            texture = 'skeleton',
            frames = {10}
        },
        ['interact-right'] = {
            texture = 'skeleton',
            frames = {11}
        },
        ['interact-up'] = {
            texture = 'skeleton',
            frames = {12}
        },
        ['interact-left'] = {
            texture = 'skeleton',
            frames = {11},
            xScale = -1
        }
    },
    ['wizard'] = {
        ['idle-right'] = {
            texture = 'wizard',
            frames = {1}
        },
        ['idle-down'] = {
            texture = 'wizard',
            frames = {4}
        },
        ['idle-left'] = {
            texture = 'wizard',
            frames = {1},
            xScale = -1
        },
        ['idle-up'] = {
            texture = 'wizard',
            frames = {7}
        },
        ['walk-right'] = {
            texture = 'wizard',
            frames = {1, 2, 1, 3},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-down'] = {
            texture = 'wizard',
            frames = {4, 5, 4, 6},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-left'] = {
            texture = 'wizard',
            frames = {1, 2, 1, 3},
            interval = DEFAULT_ANIMATION_SPEED,
            xScale = -1
        },
        ['walk-up'] = {
            texture = 'wizard',
            frames = {7, 8, 7, 9},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['interact-down'] = {
            texture = 'wizard',
            frames = {11}
        },
        ['interact-right'] = {
            texture = 'wizard',
            frames = {10}
        },
        ['interact-up'] = {
            texture = 'wizard',
            frames = {12}
        },
        ['interact-left'] = {
            texture = 'wizard',
            frames = {10},
            xScale = -1
        }
    },
    ['bat'] = {
        ['idle-up'] = {
            texture = 'bat',
            frames = {8},
        },
        ['idle-right'] = {
            texture = 'bat',
            frames = {9}
        },
        ['idle-down'] = {
            texture = 'bat',
            frames = {7}
        },
        ['idle-left'] = {
            texture = 'bat',
            frames = {9},
            xScale = -1
        },
        ['walk-up'] = {
            texture = 'bat',
            frames = {3, 4},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-right'] = {
            texture = 'bat',
            frames = {5, 6},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-down'] = {
            texture = 'bat',
            frames = {1, 2}, 
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-left'] = {
            texture = 'bat',
            frames = {5, 6},
            interval = DEFAULT_ANIMATION_SPEED,
            xScale = -1
        }
    },
    ['spider'] = {
        ['idle-up'] = {
            texture = 'spider',
            frames = {4}
        },
        ['idle-right'] = {
            texture = 'spider',
            frames = {7}
        },
        ['idle-down'] = {
            texture = 'spider',
            frames = {1}
        },
        ['idle-left'] = {
            texture = 'spider',
            frames = {7},
            xScale = -1
        },
        ['walk-up'] = {
            texture = 'spider',
            frames = {4, 5, 4, 6}
        },
        ['walk-right'] = {
            texture = 'spider',
            frames = {7, 8, 7, 9},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-down'] = {
            texture = 'spider',
            frames = {1, 2, 1, 3},
            interval = DEFAULT_ANIMATION_SPEED
        },
        ['walk-left'] = {
            texture = 'spider',
            frames = {7, 8, 7, 9},
            interval = DEFAULT_ANIMATION_SPEED,
            xScale = -1
        },
        ['hide'] = {
            texture = 'spider',
            frames = {10}
        },
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
    },
    ['projectiles'] = {
        ['wooden_sword'] = {
            texture = 'projectiles',
            frames = {1},
        },
        ['sword'] = {
            texture = 'projectiles',
            frames = {2},
        },
        ['fireball'] = {
            texture = 'projectiles',
            frames = {3},
        },
        ['ice'] = {
            texture = 'projectiles',
            frames = {4},
        },
        ['tome'] = {
            texture = 'projectiles',
            frames = {5},
        },
        ['battle_axe'] = {
            texture = 'projectiles',
            frames = {6},
        },
        ['bow'] = {
            texture = 'projectiles',
            frames = {7},
        },
        ['arrow'] = {
            texture = 'projectiles',
            frames = {8},
        },
        ['key'] = {
            texture = 'items',
            frames = {11}
        }
    },
    ['smoke'] = {
        ['appear'] = {
            texture = 'smoke',
            frames = {1}
        },
        ['disappear'] = {
            texture = 'smoke',
            frames = {1, 2, 3, 4},
            interval = 0.15,
            looping = false
        }
    }
}
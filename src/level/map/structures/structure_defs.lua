--[[
    Definitions for each structure in the game.
    @author Saverton
]]

STRUCTURE_DEFS = {
    ['fortress-entrance-overworld'] = {
        width = 3,
        height = 3,
        biome = 'grassland',
        bottomTile = 'grass',
        features = {
            [1] = {
                name = 'fortress',
                chance = 1,
                destination = 'dungeon'
            }
        },
        layouts = {
            'basic'
        },
        keepTiles = {'sand', 'stone', 'snow'}
    },
    ['fortress_room_skeletons'] = {
        width = 17,
        height = 9,
        biome = 'fortress_room',
        sideTile = 'wall_side',
        cornerTile = 'wall_corner',
        bottomTile = 'floor',
        features = {
            [1] = {
                name = 'rock',
                chance = 1
            },
            [2] = {
                name = 'spawner',
                chance = 0.75,
                enemy = 'skeleton'
            }
        },
        layouts = {
            [1] = {'ring', 'corners', 'dividers'},
            [2] = {'maze-1', 'grid'},
            [3] = {'maze-2', 'maze-3'},
        },
        keepTiles = {'floor'}
    },
    ['fortress_room_goblins'] = {
        width = 17,
        height = 9,
        biome = 'fortress_room',
        sideTile = 'wall_side',
        cornerTile = 'wall_corner',
        bottomTile = 'floor',
        features = {
            [1] = {
                name = 'rock',
                chance = 1
            },
            [2] = {
                name = 'spawner',
                chance = 1,
                enemy = 'goblin'
            }
        },
        layouts = {
            [1] = {'ring', 'corners'},
            [2] = {'maze-2', 'dividers'},
            [3] = {'maze-1', 'maze-3', 'grid'},
        },
        keepTiles = {'floor'}
    },
    ['fortress_room_bats'] = {
        width = 17,
        height = 9,
        biome = 'fortress_room',
        sideTile = 'wall_side',
        cornerTile = 'wall_corner',
        bottomTile = 'floor',
        features = {
            [1] = {
                name = 'rock',
                chance = 1
            },
            [2] = {
                name = 'spawner',
                chance = 0.9,
                enemy = 'bat'
            }
        },
        layouts = {
            [1] = {'corners'},
            [2] = {'maze-2', 'dividers'},
            [3] = {'maze-1', 'maze-3', 'grid', 'ring'},
        },
        keepTiles = {'floor'}
    },
    ['fortress_room_empty'] = {
        width = 17,
        height = 9,
        biome = 'fortress_room',
        sideTile = 'wall_side',
        cornerTile = 'wall_corner',
        bottomTile = 'floor',
        features = {
            [1] = {
                name = 'rock',
                chance = 1
            }
        },
        layouts = {
            [1] = {'ring', 'grid', 'dividers'},
            [2] = {'maze-1', 'maze-3',  'maze-2'}
        },
        keepTiles = {'floor'}
    },
    ['fortress_exit'] = {
        width = 17,
        height = 9,
        biome = 'fortress_room',
        sideTile = 'wall_side',
        cornerTile = 'wall_corner',
        bottomTile = 'floor',
        features = {
            [1] = {
                name = 'exit',
                chance = 1,
                destination = 'overworld-1'
            }
        },
        layouts = {[1] = {'exit-1'}},
        keepTiles = {'floor'}
    },
    ['fortress_treasure'] = {
        width = 17,
        height = 9,
        biome = 'fortress_room',
        sideTile = 'wall_side',
        cornerTile = 'wall_corner',
        bottomTile = 'floor',
        features = {
            [1] = {
                name = 'rock',
                chance = 1 
            },
            [2] = {
                name = 'chest',
                chance = 1
            },
            [3] = {
                name = 'exit',
                chance = 1,
                destination = 'overworld-1'
            },
            [4] = {
                name = 'spawner',
                chance = 1,
                enemy = 'wizard'
            },
            [5] = {
                name = 'key_door',
                chance = 1
            }
        },
        layouts = {[1] = {'treasure-1'}},
        keepTiles = {'floor'}
    }
}

LAYOUT_DEFS = {
    ['basic'] = {
        [2] = {0, 1}
    },
    ['empty'] = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    },
    ['grid'] = {
        [1] = {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        [2] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ,0 ,1, 0, 1},
        [4] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ,0 ,1, 0, 1},
        [5] = {0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0},
        [6] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ,0 ,1, 0, 1},
        [8] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ,0 ,1, 0, 1},
        [9] = {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
    },
    ['ring'] = {
        [2] = {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ,1 ,1, 1, 1, 2},
        [3] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        [4] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        [5] = {0, 1, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 1, 0},
        [6] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        [7] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        [8] = {2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ,1 ,1, 1, 1, 0},
    },
    ['dividers'] = {
        [2] = {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 2, 0, 0},
        [3] = {0, 0, 0, 2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        [4] = {0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
        [5] = {0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0},
        [6] = {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0},
        [7] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0},
        [8] = {0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
    },
    ['corners'] = {
        [1] = {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        [9] = {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
    },
    ['maze-1'] = {
        {1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 2, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1},
        {1, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1},
        {1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1},
        {0, 0, 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 1, 0, 0},
        {1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1},
        {1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1},
        {1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 2, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1},
    },
    ['maze-2'] = {
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0},
        {0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0},
        {0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0},
        {0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0},
        {0, 0, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0},
        {0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0},
        {0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0},
        {0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0},
    },
    ['maze-3'] = {
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
        {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
        {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    },
    ['exit-1'] = {
        [5] = {0, 0, 0, 0, 1}
    },
    ['treasure-1'] = {
        [2] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0, 0, 0, 0, 0, 0},
        [3] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        [4] = {0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0},
        [5] = {0, 0, 0, 5, 2, 0, 1, 0, 4, 0, 1, 3, 0, 0, 0, 0, 0},
        [6] = {0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0},
        [7] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        [8] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0, 0, 0, 0, 0, 0},
    }
}
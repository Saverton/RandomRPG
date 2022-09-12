--[[
    Definitions for each structure in the game.
    @author Saverton
]]

STRUCTURE_DEFS = {
    ['fortress_room_skeletons'] = {
        width = 17,
        height = 9,
        biome = 'fortress_room',
        border_tile = 'wall_edge',
        bottom_tile = 'floor',
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
        layouts = {'grid', 'maze-1', 'ring'},
        keepTiles = {'floor'}
    },
    ['fortress_room_goblins'] = {
        width = 17,
        height = 9,
        biome = 'fortress_room',
        border_tile = 'wall_edge',
        bottom_tile = 'floor',
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
        layouts = {'grid', 'maze-1', 'ring'},
        keepTiles = {'floor'}
    },
    ['fortress_room_empty'] = {
        width = 17,
        height = 9,
        biome = 'fortress_room',
        border_tile = 'wall_edge',
        bottom_tile = 'floor',
        features = {
            [1] = {
                name = 'rock',
                chance = 1
            }
        },
        layouts = {'grid', 'maze-1', 'ring'},
        keepTiles = {'floor'}
    },
    ['fortress_exit'] = {
        width = 17,
        height = 9,
        biome = 'fortress_room',
        border_tile = 'wall_edge',
        bottom_tile = 'floor',
        features = {
            [1] = {
                name = 'exit',
                chance = 1,
                destination = 'overworld-1'
            }
        },
        layouts = {'exit-1'},
        keepTiles = {'floor'}
    },
    ['fortress_treasure'] = {
        width = 17,
        height = 9,
        biome = 'fortress_room',
        border_tile = 'wall_edge',
        bottom_tile = 'floor',
        features = {
            [1] = {
                name = 'rock',
                chance = 0.75
            },
            [2] = {
                name = 'chest',
                chance = 1
            },
            [3] = {
                name = 'exit',
                chance = 1,
                destination = 'overworld-1'
            }
        },
        layouts = {'treasure-1'},
        keepTiles = {'floor'}
    }
}

LAYOUT_DEFS = {
    ['grid'] = {
        [1] = {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        [2] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ,0 ,1, 0, 1},
        [4] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ,0 ,1, 0, 1},
        [5] = {0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0},
        [6] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ,0 ,1, 0, 1},
        [8] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ,0 ,1, 0, 1},
        [9] = {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
    },
    ['ring'] = {
        [2] = {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ,1 ,1, 1, 1, 0},
        [3] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2},
        [4] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        [5] = {0, 1, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 1, 0},
        [6] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        [7] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        [8] = {2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ,1 ,1, 1, 1, 0},
    },
    ['maze-1'] = {
        {1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0},
        {1, 0, 2, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 0},
        {1, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0},
        {1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1},
        {0, 0, 1, 0, 1, 0, 0, 0, 2, 0, 0, 0, 1, 0, 1, 0, 0},
        {1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1},
        {0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1},
        {0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 2, 0, 1},
        {0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1},
    },
    ['exit-1'] = {
        [5] = {0, 0, 0, 0, 1}
    },
    ['treasure-1'] = {
        [2] = {0, 1, 1, 1, 1, 1, 1, 1, 1, 1 ,1 ,1, 1, 1, 1, 1, 0},
        [3] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        [4] = {0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0},
        [5] = {0, 1, 0, 1, 0, 0, 2, 0, 0, 0, 3, 0, 0, 1, 0, 1, 0},
        [6] = {0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0},
        [7] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        [8] = {0, 1, 1, 1, 1, 1, 1, 1, 1, 1 ,1 ,1, 1, 1, 1, 1, 0},
    }
}
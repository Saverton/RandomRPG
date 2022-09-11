--[[
    Definitions for each structure in the game.
    @author Saverton
]]

STRUCTURE_DEFS = {
    ['fortress_room_grid'] = {
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
        layouts = {'grid'},
        keepTiles = {'floor'}
    },
    ['fortress_room_ring'] = {
        width = 17,
        height = 9,
        biome = 'fortress_room',
        border_tile = 'wall_edge',
        bottom_tile = 'floor',
        features = {
            [1] = {
                name = 'rock',
                chance = 0.75
            }
        },
        layouts = {'ring'},
        keepTiles = {'floor'}
    },
    ['fortress_room_maze'] = {
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
        layouts = {'maze-1'},
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
        [2] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ,0 ,1, 0, 1},
        [4] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ,0 ,1, 0, 1},
        [6] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ,0 ,1, 0, 1},
        [8] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ,0 ,1, 0, 1}
    },
    ['ring'] = {
        [2] = {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ,1 ,1, 1, 1, 0},
        [3] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        [4] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        [5] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        [6] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        [7] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        [8] = {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ,1 ,1, 1, 1, 0},
    },
    ['maze-1'] = {
        {1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0},
        {1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 0},
        {1, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0},
        {1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1},
        {0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0},
        {1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1},
        {0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1},
        {0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1},
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
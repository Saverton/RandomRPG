--[[
    Definitions for each structure in the game.
    @author Saverton
]]

STRUCTURE_DEFS = {
    ['fortress_room_1'] = {
        width = 5,
        height = 5,
        biome = 'fortress_room',
        border_tile = 'wall_edge',
        bottom_tile = 'floor',
        features = {
            [1] = {
                name = 'rock',
                chance = 1
            }
        },
        layout = {
            {0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0},
            {0, 0, 1, 0, 0},
            {0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0}
        },
        keepTiles = {'floor'}
    },
    ['fortress_room_2'] = {
        width = 9,
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
        layout = {
            [2] = {0, 0, 0, 0, 1, 0, 0, 0, 0},
            [3] = {0, 0, 0, 0, 1, 0, 0, 0, 0},
            [5] = {0, 1, 1, 0, 0, 0, 1, 1, 0},
            [7] = {0, 0, 0, 0, 1, 0, 0, 0, 0},
            [8] = {0, 0, 0, 0, 1, 0, 0, 0, 0},
        },
        keepTiles = {'floor'}
    },
    ['fortress_room_3'] = {
        width = 5,
        height = 5,
        biome = 'fortress_room',
        border_tile = 'wall_edge',
        bottom_tile = 'floor',
        features = {
            [1] = {
                name = 'rock',
                chance = 1
            }
        },
        layout = {
            {0, 0, 0, 0, 0},
            {0, 1, 0, 1, 0},
            {0, 0, 0, 0, 0},
            {0, 1, 0, 1, 0},
            {0, 0, 0, 0, 0}
        },
        keepTiles = {'floor'}
    },
    ['fortress_exit'] = {
        width = 5,
        height = 5,
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
        layout = {
            [5] = {0, 0, 0, 0, 1}
        },
        keepTiles = {'floor'}
    },
    ['fortress_treasure'] = {
        width = 5,
        height = 5,
        biome = 'fortress_room',
        border_tile = 'wall_edge',
        bottom_tile = 'floor',
        features = {
            [1] = {
                name = 'rock',
                chance = 0.5
            },
            [2] = {
                name = 'chest',
                chance = 1
            }
        },
        layout = {
            [2] = {0, 1, 0, 1, 0},
            [3] = {0, 0, 2, 0, 0},
            [4] = {0, 1, 0, 1, 0}
        },
        keepTiles = {'floor'}
    }
}
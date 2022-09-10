--[[
    Definitions for every biome in the game.
    @author Saverton
]]

BIOME_DEFS = {
    ['grassland'] = {
        id = 1,
        name = 'grassland',
        tiles = {
            {
                tileType = 'grass',
                proc = 1
            }
        },
        enemies = {
            {
                name = 'goblin',
                proc = 1
            }
        },
        spawnRate = 0.02,
        features = {
            {
                name = 'tree', 
                proc = 0.9
            },
            {
                name = 'rock', 
                proc = 0.1
            }
        },
        featProc = 0.05
    },
    ['mountain'] = {
        id = 2,
        name = 'mountain',
        tiles = {
            {
                tileType = 'stone',
                proc = 1
            }
        },
        enemies = {
            {
                name = 'skeleton',
                proc = 1
            }
        },
        spawnRate = 0.05,
        features = {
            {
                name = 'rock', 
                proc = 0.995
            },
            {
                name = 'chest',
                proc = 0.005
            }
        },
        featProc = 0.5
    },
    ['water'] = {
        id = 3,
        name = 'water',
        tiles = {
            {
                tileType = 'water',
                proc = 1
            }
        },
        enemies = {},
        spawnRate = 0,
        features = {},
        featProc = 0
    },
    ['desert'] = {
        id = 4,
        name = 'desert',
        tiles = {
            {
                tileType = 'sand',
                proc = 1
            }
        },
        enemies = {
            {
                name = 'goblin',
                proc = 1
            }
        },
        spawnRate = 0.05,
        features = {
            {
                name = 'cactus',
                proc = 0.95
            },
            {
                name = 'rock',
                proc = 0.05
            }
        },
        featProc = 0.1
    },
    ['snow_forest'] = {
        id = 5,
        name = 'snow_forest',
        tiles = {
            {
                tileType = 'snow',
                proc = 1
            }
        },
        enemies = {
            {
                name = 'goblin',
                proc = 1
            }
        },
        spawnRate = 0.02,
        features = {
            {
                name = 'snow_tree',
                proc = 1
            }
        },
        featProc = 0.25
    },
    ['snow_field'] = {
        id = 5,
        name = 'snow_field',
        tiles = {
            {
                tileType = 'snow',
                proc = 1
            }
        },
        enemies = {
            {
                name = 'goblin',
                proc = 1
            }
        },
        spawnRate = 0.02,
        features = {
            {
                name = 'snow_tree',
                proc = 0.5
            },
            {
                name = 'rock',
                proc = 0.5
            }
        },
        featProc = 0.025
    },
    ['beach'] = {
        id = 6,
        name = 'beach',
        tiles = {
            {
                tileType = 'sand',
                proc = 1
            }
        },
        enemies = {
            {
                name = 'goblin',
                proc = 1
            }
        },
        spawnRate = 0.05,
        features = {},
        featProc = 0
    },
    ['fortress_inside'] = {
        id = 7,
        name = 'fortress_inside',
        tiles = {
            {
                tileType = 'wall_inside',
                proc = 1
            }
        },
        enemies = {},
        spawnRate = 0,
        features = {},
        featProc = 0
    },
    ['fortress_wall'] = {
        id = 8,
        name = 'fortress_wall',
        tiles = {
            {
                tileType = 'wall_edge',
                proc = 1
            }
        },
        enemies = {},
        spawnRate = 0,
        features = {},
        featProc = 0
    },
    ['fortress_room'] = {
        id = 9,
        name = 'fortress_room',
        tiles = {
            {
                tileType = 'floor',
                proc = 1
            }
        },
        enemies = {
            {
                name = 'skeleton',
                proc = 1
            }
        },
        spawnRate = 0.05,
        features = {},
        featProc = 0
    }
}
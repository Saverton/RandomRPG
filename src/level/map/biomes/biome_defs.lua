--[[
    Definitions for every biome in the game.
    @author Saverton
]]

BIOME_DEFS = {
    ['empty'] = {
        id = 0,
        name = 'empty',
        tiles = {
            {
                tileType = 'water',
                chance = 1
            }
        },
        enemies = {},
        features = {},
        featureChance = 0
    },
    ['grassland'] = {
        id = 1,
        name = 'grassland',
        tiles = {
            {
                tileType = 'grass',
                chance = 1
            }
        },
        enemies = {
            {
                name = 'goblin',
                spawnChance = 1
            }
        },
        spawnRate = 0.02,
        features = {
            {
                name = 'tree', 
                chance = 0.9
            },
            {
                name = 'rock', 
                chance = 0.1
            }
        },
        featureChance = 0.05
    },
    ['mountain'] = {
        id = 2,
        name = 'mountain',
        tiles = {
            {
                tileType = 'stone',
                chance = 1
            }
        },
        enemies = {
            {
                name = 'skeleton',
                spawnChance = 1
            }
        },
        spawnRate = 0.05,
        features = {
            {
                name = 'rock', 
                chance = 0.999
            },
            {
                name = 'chest',
                chance = 0.001
            }
        },
        featureChance = 0.5
    },
    ['water'] = {
        id = 3,
        name = 'water',
        tiles = {
            {
                tileType = 'water',
                chance = 1
            }
        },
        enemies = {},
        spawnRate = 0,
        features = {},
        featureChance = 0
    },
    ['desert'] = {
        id = 4,
        name = 'desert',
        tiles = {
            {
                tileType = 'sand',
                chance = 1
            }
        },
        enemies = {
            {
                name = 'goblin',
                spawnChance = 1
            }
        },
        spawnRate = 0.05,
        features = {
            {
                name = 'cactus',
                chance = 0.95
            },
            {
                name = 'rock',
                chance = 0.05
            }
        },
        featureChance = 0.1
    },
    ['snow_forest'] = {
        id = 5,
        name = 'snow_forest',
        tiles = {
            {
                tileType = 'snow',
                chance = 1
            }
        },
        enemies = {
            {
                name = 'goblin',
                spawnChance = 1
            }
        },
        spawnRate = 0.02,
        features = {
            {
                name = 'snow_tree',
                chance = 1
            }
        },
        featureChance = 0.25
    },
    ['snow_field'] = {
        id = 5,
        name = 'snow_field',
        tiles = {
            {
                tileType = 'snow',
                chance = 1
            }
        },
        enemies = {
            {
                name = 'goblin',
                spawnChance = 1
            }
        },
        spawnRate = 0.02,
        features = {
            {
                name = 'snow_tree',
                chance = 0.5
            },
            {
                name = 'rock',
                chance = 0.5
            }
        },
        featureChance = 0.025
    },
    ['beach'] = {
        id = 6,
        name = 'beach',
        tiles = {
            {
                tileType = 'sand',
                chance = 1
            }
        },
        enemies = {
            {
                name = 'goblin',
                spawnChance = 1
            }
        },
        spawnRate = 0.05,
        features = {},
        featureChance = 0
    },
    ['fortress_inside'] = {
        id = 7,
        name = 'fortress_inside',
        tiles = {
            {
                tileType = 'wall_inside',
                chance = 1
            }
        },
        enemies = {},
        spawnRate = 0,
        features = {},
        featureChance = 0
    },
    ['fortress_wall'] = {
        id = 8,
        name = 'fortress_wall',
        tiles = {
            {
                tileType = 'wall_edge',
                chance = 1
            }
        },
        enemies = {},
        spawnRate = 0,
        features = {},
        featureChance = 0
    },
    ['fortress_room'] = {
        id = 9,
        name = 'fortress_room',
        tiles = {
            {
                tileType = 'floor',
                chance = 1
            }
        },
        enemies = {},
        spawnRate = 0.05,
        features = {},
        featureChance = 0
    }
}
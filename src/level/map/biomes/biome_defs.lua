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
        featureChance = 0.05,
        subBiomes = {{name='grassland_forest', minSize=5, maxSize=10}}
    },
    ['grassland_forest'] = {
        id = 2,
        name = 'grassland_forest',
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
        spawnRate = 0.04,
        features = {
            {
                name = 'tree', 
                chance = 1
            }
        },
        featureChance = 0.25
    },
    ['mountain'] = {
        id = 3,
        name = 'mountain',
        tiles = {
            {
                tileType = 'stone',
                chance = 1
            }
        },
        enemies = {
            {
                name = 'spider',
                spawnChance = 1
            }
        },
        spawnRate = 0.025,
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
        featureChance = 0.25,
        subBiomes = {{name='mountain_cluster', minSize=7, maxSize=15}}
    },
    ['mountain_cluster'] = {
        id = 4,
        name = 'mountain_cluster',
        tiles = {
            {
                tileType = 'stone',
                chance = 1
            }
        },
        enemies = {
            {
                name = 'spider',
                spawnChance = 1
            }
        },
        spawnRate = 0.05,
        features = {
            {
                name = 'rock', 
                chance = 0.998
            },
            {
                name = 'chest',
                chance = 0.002
            }
        },
        featureChance = 0.5
    },
    ['water'] = {
        id = 5,
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
        id = 6,
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
        featureChance = 0.1,
        subBiomes = {{name='desert_oasis', minSize=4, maxSize=7}}
    },
    ['desert_oasis'] = {
        id = 7,
        name = 'desert_oasis',
        tiles = {
            {
                tileType = 'water',
                chance = 1
            }
        },
        enemies = {},
        spawnRate = 0.0,
        features = {},
        featureChance = 0.0
    },
    ['snow_forest'] = {
        id = 8,
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
        id = 9,
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
        featureChance = 0.025,
        subBiomes = {{name='snow_forest', minSize=5, maxSize=10}}
    },
    ['beach'] = {
        id = 10,
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
        id = 11,
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
        id = 12,
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
        id = 13,
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
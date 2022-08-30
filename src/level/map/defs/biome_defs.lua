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
        enemies = {},
        spawnRate = 0.05,
        features = {
            {
                name = 'rock', 
                proc = 1
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
        features = {}
    }
}
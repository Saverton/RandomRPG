--[[
    Definitions for every biome in the game.
    @author Saverton
]]

BIOME_DEFS = {
    ['Grassland'] = {
        id = 1,
        name = 'Grassland',
        tiles = {
            {
                tileType = 'Grass',
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
                feature = 'Tree', 
                proc = 0.9
            },
            {
                feature = 'Rock', 
                proc = 0.1
            }
        },
        featProc = 0.05
    },
    ['Mountain'] = {
        id = 2,
        name = 'Mountain',
        tiles = {
            {
                tileType = 'Stone',
                proc = 1
            }
        },
        enemies = {},
        spawnRate = 0.05,
        features = {
            {
                feature = 'Rock', 
                proc = 1
            }
        },
        featProc = 0.5
    }
}
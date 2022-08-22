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
                tileType = TILE_DEFS['Grass'],
                proc = 1
            }
        },
        enemies = {},
        features = {
            {
                feature = FEATURE_DEFS['Tree'], 
                proc = 0.9
            },
            {
                feature = FEATURE_DEFS['Rock'], 
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
                tileType = TILE_DEFS['Stone'],
                proc = 1
            }
        },
        enemies = {},
        features = {
            {
                feature = FEATURE_DEFS['Rock'], 
                proc = 1
            }
        },
        featProc = 0.1
    }
}
--[[
    Table dictionary with different generation definitions.
    @author Saverton
]]

LEVEL_DEFS = {
    ['overworld'] = {
        size = DEFAULT_MAP_SIZE,
        minBiomes = 15,
        maxBiomes = 25,
        minPaths = 3,
        maxPaths = 5,
        minPathLength = 20,
        maxPathLength = 50,
        minPathSegment = 2,
        maxPathSegment = 10,
        minBiomeSize = 5,
        maxBiomeSize = 20,
        baseBiome = 'grassland',
        biomes = {'mountain', 'desert', 'snow_forest', 'snow_field'},
        generateBorder = true,
        borderBiome = 'water',
        pathBiome = 'water',
        pathBorderBiome = 'beach',
        spawnNpcs = true,
        gateways = {{name = 'fortress', destination = 'fortress-1'}, {name = 'fortress', destination = 'fortress-2'}, 
            {name = 'fortress', destination = 'fortress-3'}}
    },
    ['fortress'] = {
        size = 100,
        minBiomes = 0,
        maxBiomes = 0,
        minPaths = 1,
        maxPaths = 1,
        minPathLength = 100,
        maxPathLength = 200,
        minPathSegment = 10,
        maxPathSegment = 15,
        minBiomeSize = 0,
        maxBiomeSize = 0,
        baseBiome = 'fortress_inside',
        biomes = {},
        generateBorder = false,
        structures = {'fortress_room_1', 'fortress_room_2', 'fortress_room_3'},
        start = {
            x = 50,
            y = 50,
            dir = 1
        },
        pathBiome = 'fortress_room',
        pathBorderBiome = 'fortress_wall',
        spawnNpcs = false,
        structureAtStart = 'fortress_exit',
        structureAtEnd = 'fortress_treasure',
        structureAtTurnChance = 0.75
    }
}
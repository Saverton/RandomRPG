--[[
    Table dictionary with different generation definitions.
    @author Saverton
]]

LEVEL_DEFS = {
    ['classic'] = {
        width = DEFAULT_MAP_SIZE,
        height = DEFAULT_MAP_SIZE,
        minBiomes = 10,
        maxBiomes = 15,
        minPaths = 4,
        maxPaths = 6,
        minPathLength = 30,
        maxPathLength = 80,
        minPathSegment = 2,
        maxPathSegment = 10,
        minBiomeSize = 5,
        maxBiomeSize = 15,
        baseBiome = 'grassland',
        biomes = {'mountain'},
        generateBorder = true,
        borderBiome = 'water',
        pathBiome = 'water',
        pathBorderBiome = 'beach',
        spawnNpcs = true,
        gateways = {{name = 'fortress', destination = 'dungeon-1'}, {name = 'fortress', destination = 'dungeon-2'}, 
            {name = 'fortress', destination = 'dungeon-3'}}
    },
    ['wasteland'] = {
        width = DEFAULT_MAP_SIZE,
        height = DEFAULT_MAP_SIZE,
        minBiomes = 3,
        maxBiomes = 5,
        minPaths = 3,
        maxPaths = 5,
        minPathLength = 5,
        maxPathLength = 20,
        minPathSegment = 1,
        maxPathSegment = 3,
        minBiomeSize = 5,
        maxBiomeSize = 10,
        baseBiome = 'desert',
        biomes = {'grassland'},
        generateBorder = true,
        borderBiome = 'water',
        pathBiome = 'water',
        pathBorderBiome = 'beach',
        spawnNpcs = true,
        gateways = {{name = 'fortress', destination = 'dungeon-1'}, {name = 'fortress', destination = 'dungeon-2'}, 
            {name = 'fortress', destination = 'dungeon-3'}}
    },
    ['winter_wonderland'] = { 
        width = DEFAULT_MAP_SIZE,
        height = DEFAULT_MAP_SIZE,
        minBiomes = 10,
        maxBiomes = 15,
        minPaths = 5,
        maxPaths = 7,
        minPathLength = 50,
        maxPathLength = 100,
        minPathSegment = 2,
        maxPathSegment = 7,
        minBiomeSize = 5,
        maxBiomeSize = 15,
        baseBiome = 'snow_forest',
        biomes = {'mountain', 'snow_field'},
        generateBorder = true,
        borderBiome = 'water',
        pathBiome = 'water',
        pathBorderBiome = 'snow_field',
        spawnNpcs = true,
        gateways = {{name = 'fortress', destination = 'dungeon-1'}, {name = 'fortress', destination = 'dungeon-2'}, 
            {name = 'fortress', destination = 'dungeon-3'}}
    },
    ['winter_wasteland'] = {
        width = DEFAULT_MAP_SIZE,
        height = DEFAULT_MAP_SIZE,
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
        baseBiome = 'snow_field',
        biomes = {'mountain'},
        generateBorder = true,
        borderBiome = 'water',
        pathBiome = 'water',
        pathBorderBiome = 'snow_field',
        spawnNpcs = true,
        gateways = {{name = 'fortress', destination = 'dungeon-1'}, {name = 'fortress', destination = 'dungeon-2'}, 
            {name = 'fortress', destination = 'dungeon-3'}}
    }
}

DUNGEON_DEFS = {
    ['dungeon'] = {
        rooms = {'fortress_room_skeletons', 'fortress_room_goblins', 'fortress_room_empty'},
        floorTile = 'floor',
        pathBorderTile = 'wall_edge',
        insideTile = 'wall_inside',
        startRoom = 'fortress_exit',
        endRoom = 'fortress_treasure'
    }
}
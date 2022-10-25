--[[
    Table dictionary with different generation definitions.
    @author Saverton
]]

LEVEL_DEFS = {
    ['overworld'] = {
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
        biomes = {'grassland', 'mountain', 'snow_field', 'desert', 'water'},
        generateBorder = true,
        borderBiome = 'water',
        fallbackBorderBiome = 'beach',
        spawnNpcs = true,
        gateways = {{name = 'fortress', destination = 'dungeon-1'}, {name = 'fortress', destination = 'dungeon-2'}, 
            {name = 'fortress', destination = 'dungeon-3'}},
        music = 'overworld'
    },
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
        biomes = {'grassland', 'mountain'},
        generateBorder = true,
        borderBiome = 'water',
        pathBiome = 'water',
        pathBorderBiome = 'beach',
        spawnNpcs = true,
        gateways = {{name = 'fortress', destination = 'dungeon-1'}, {name = 'fortress', destination = 'dungeon-2'}, 
            {name = 'fortress', destination = 'dungeon-3'}},
        music = 'overworld'
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
        biomes = {'desert', 'grassland'},
        generateBorder = true,
        borderBiome = 'water',
        pathBiome = 'water',
        pathBorderBiome = 'beach',
        spawnNpcs = true,
        gateways = {{name = 'fortress', destination = 'dungeon-1'}, {name = 'fortress', destination = 'dungeon-2'}, 
            {name = 'fortress', destination = 'dungeon-3'}},
        music = 'overworld'
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
        biomes = {'snow_forest', 'mountain', 'snow_field'},
        generateBorder = true,
        borderBiome = 'water',
        pathBiome = 'water',
        pathBorderBiome = 'snow_field',
        spawnNpcs = true,
        gateways = {{name = 'fortress', destination = 'dungeon-1'}, {name = 'fortress', destination = 'dungeon-2'}, 
            {name = 'fortress', destination = 'dungeon-3'}},
        music = 'overworld'
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
        biomes = {'snow_field', 'mountain'},
        generateBorder = true,
        borderBiome = 'water',
        pathBiome = 'water',
        pathBorderBiome = 'snow_field',
        spawnNpcs = true,
        gateways = {{name = 'fortress', destination = 'dungeon-1'}, {name = 'fortress', destination = 'dungeon-2'}, 
            {name = 'fortress', destination = 'dungeon-3'}},
        music = 'overworld'
    },
    ['dungeon'] = {
        rooms = {
            [1] = {'fortress_room_goblins', 'fortress_room_empty'}, 
            [2] = {'fortress_room_skeletons'},
            [3] = {'fortress_room_bats'}
        },
        floorTile = 'floor',
        wallTile = 'wall_side',
        pathBorderTile = 'wall_block',
        insideTile = 'wall_inside',
        startRooms = {[1] = {'fortress_exit'}},
        endRooms = {[1] = {'fortress_treasure'}},
        music = 'dungeon',
        introMusic = nil
    }
}

MUSIC_DEFS = {
    ['overworld'] = {
        track = 'overworld',
        intro = nil
    },
    ['underground'] = {
        track = 'underground',
        intro = nil
    },
    ['dungeon'] = {
        track = 'dungeon',
        intro = 'dungeon_intro'
    }
}
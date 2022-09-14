--[[
    Table dictionary with different generation definitions.
    @author Saverton
]]

LEVEL_DEFS = {
    ['overworld'] = {
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
        baseBiome = 'grassland',
        biomes = {'mountain', 'desert', 'snow_forest', 'snow_field'},
        generateBorder = true,
        borderBiome = 'water',
        pathBiome = 'water',
        pathBorderBiome = 'beach',
        spawnNpcs = true,
        gateways = {{name = 'fortress', destination = 'dungeon-1'}, {name = 'fortress', destination = 'dungeon-2'}, 
            {name = 'fortress', destination = 'dungeon-3'}}
    },
    ['fortress'] = {
        spawnNpcs = false
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
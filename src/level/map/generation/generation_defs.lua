--[[
    Table dictionary with different generation definitions.
    @author Saverton
]]

LEVEL_DEFS = {
    ['overworld'] = {
        width = DEFAULT_MAP_SIZE,
        height = DEFAULT_MAP_SIZE,
        biomes = {'grassland', 'mountain', 'snow_field', 'desert', 'water'},
        generateBorder = true,
        borderBiome = 'water',
        fallbackBorderBiome = 'beach',
        minSubBiomes = 10,
        maxSubBiomes = 15,
        spawnNpcs = true,
        music = 'overworld',
        numberOfDungeons = 3
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
    },
    ['underground'] = {
        width = DEFAULT_MAP_SIZE,
        height = DEFAULT_MAP_SIZE,
        biomes = {'mountain'},
        generateBorder = true,
        borderBiome = 'water',
        fallbackBorderBiome = 'beach',
        minSubBiomes = 10,
        maxSubBiomes = 15,
        spawnNpcs = true,
        music = 'overworld',
        numberOfDungeons = 3
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
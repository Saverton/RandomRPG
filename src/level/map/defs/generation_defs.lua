--[[
    Table dictionary with different generation definitions.
    @author Saverton
]]

LEVEL_DEFS = {
    ['overworld'] = {
        size = DEFAULT_MAP_SIZE,
        minBiomes = 15,
        maxBiomes = 25,
        minRivers = 3,
        maxRivers = 5,
        minBiomeSize = 5,
        maxBiomeSize = 20,
        baseBiome = 'grassland',
        biomes = {'mountain', 'desert', 'snow_forest', 'snow_field'},
        generateBorder = true,
        borderBiome = 'water'
    },
    ['fortress'] = {
        size = 50,
        minBiomes = 0,
        maxBiomes = 0,
        minRivers = 0,
        maxRivers = 0,
        minBiomeSize = 0,
        maxBiomeSize = 0,
        baseBiome = 'fortress_wall',
        biomes = {},
        generateBorder = false,
        structures = {'fortress_room'}
    }
}
--[[
    Contains functions to generate Biomes and Tiles on the map.
    @author Saverton
]]

function GenerateBiomes(size)
    local biomeMap = {}
    local numOfMtns = 5

    -- fill with grassland by default
    for row = 1, size, 1 do
        biomeMap[row] = {}
        for column = 1, size, 1 do
            biomeMap[row][column] = Biome(BIOME_DEFS['Grassland'])
        end
    end

    -- generate mountains locations and sizes
    for i = 1, numOfMtns, 1 do
        local x, y= math.random(1, size), math.random(1, size)
        local mtnSize = math.random(MOUNTAIN_MIN_SIZE, MOUNTAIN_MAX_SIZE)
        for row = x, mtnSize, 1 do
            for column = y, mtnSize, 1 do
                biomeMap[row][column] = Biome(BIOME_DEFS['Mountain'])
            end
        end
    end

    return biomeMap
end

function GenerateTiles(size, biomeMap)
    local tileMap = {}

    for row = 1, size, 1 do
        tileMap[row] = {}
        for column = 1, size, 1 do
            tileMap[row][column] = Tile(TILE_DEFS[biomeMap[row][column]:getTile()], row, column)
        end
    end

    return tileMap
end
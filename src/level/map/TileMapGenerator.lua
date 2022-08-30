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
            biomeMap[row][column] = Biome(BIOME_DEFS['grassland'])
        end
    end

    -- generate mountains locations and sizes
    for i = 1, numOfMtns, 1 do
        local mtnSize = math.random(MOUNTAIN_MIN_SIZE, MOUNTAIN_MAX_SIZE)
        local x, y= math.random(1, size - mtnSize), math.random(1, size - mtnSize)
        for row = x, x + mtnSize, 1 do
            for column = y, y + mtnSize, 1 do
                biomeMap[row][column] = Biome(BIOME_DEFS['mountain'])
            end
        end
    end

    -- generate water around edges and a river that cuts through the world
    for i = 1, size, 1 do
        biomeMap[1][i] = Biome(BIOME_DEFS['water'])
        biomeMap[i][size] = Biome(BIOME_DEFS['water'])
        biomeMap[size][i] = Biome(BIOME_DEFS['water'])
        biomeMap[i][1] = Biome(BIOME_DEFS['water'])
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
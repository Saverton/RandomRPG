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

    --generate river
    local startDirection = {
        [1] = {
            x = math.random(2, size - 1),
            y = 1,
            dir = 3
        },
        [2] = {
            x = size,
            y = math.random(2, size - 1),
            dir = 4
        },
        [3] = {
            x = math.random(2, size - 1),
            y = size,
            dir = 1
        },
        [4] = {
            x = 1,
            y = math.random(2, size - 1),
            dir = 2
        }
    }
    local choice = math.random(1, 4)
    local x = startDirection[choice].x
    local y = startDirection[choice].y
    local dir = startDirection[choice].dir
    while true do
        local length = math.random(2, 10)
        if dir == 1 then
            for i = 1, math.min(length, y - 1), 1 do
                biomeMap[x][y - i] = Biome(BIOME_DEFS['water'])
            end
            y = y - length
        elseif dir == 2 then
            for i = 1, math.min(length, size - x - 1), 1 do
                biomeMap[x + i][y] = Biome(BIOME_DEFS['water'])
            end
            x = x + length
        elseif dir == 3 then
            for i = 1, math.min(length, size - y - 1), 1 do
                biomeMap[x][y + i] = Biome(BIOME_DEFS['water'])
            end
            y = y + length
        elseif dir == 4 then
            for i = 1, math.min(length, x - 1), 1 do
                biomeMap[x - i][y] = Biome(BIOME_DEFS['water'])
            end
            x = x - length
        end

        --check if out of map
        if x <= 1 or x >= size or y <= 1 or y >= size then
            break
        end

        -- change direction
        local backwardsDir = ((dir + 1) % 4) + 1
        dir = math.random(4)
        while dir == backwardsDir do
            dir = math.random(4)
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
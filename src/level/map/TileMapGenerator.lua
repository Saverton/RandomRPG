--[[
    Contains functions to generate Biomes and Tiles on the map.
    @author Saverton
]]

function GenerateBiomes(size)
    local biomeMap = {}
    local numOfBiomes = math.random(15, 25)
    local numOfRivers = math.random(1, 5)
    local biomes = {'mountain', 'desert', 'snow_forest', 'snow_field'}

    -- fill with grassland by default
    for col = 1, size, 1 do
        biomeMap[col] = {}
        for row = 1, size, 1 do
            biomeMap[col][row] = Biome('grassland')
        end
    end

    -- generate biomes at different locations and sizes
    for i = 1, numOfBiomes, 1 do
        local biomeSize = math.random(BIOME_MIN_SIZE, BIOME_MAX_SIZE)
        local biomeType = biomes[math.random(#biomes)]
        local x, y= math.random(1, size - biomeSize), math.random(1, size - biomeSize)
        for col = x, x + biomeSize, 1 do
            for row = y, y + biomeSize, 1 do
                biomeMap[col][row] = Biome(biomeType)
            end
        end
    end

    -- generate water around edges and a river that cuts through the world
    for i = 1, size, 1 do
        biomeMap[1][i] = Biome('water')
        biomeMap[i][size] = Biome('water')
        biomeMap[size][i] = Biome('water')
        biomeMap[i][1] = Biome('water')
    end

    --generate rivers
    for i = 1, numOfRivers, 1 do
        GenerateRiver(biomeMap, size)
    end
    return biomeMap
end

function GenerateRiver(biomeMap, size)
    local riverLength = math.random(20, 50)
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
                biomeMap[x][y - i] = Biome('water')
                if biomeMap[x - 1][y - i].name ~= 'water' and biomeMap[x - 1][y - i].name ~= 'mountain' then
                    biomeMap[x - 1][y - i] = Biome('beach')
                end if biomeMap[x + 1][y - i].name ~= 'water' and biomeMap[x + 1][y - i].name ~= 'mountain' then
                    biomeMap[x + 1][y - i] = Biome('beach')
                end
            end
            y = y - length
        elseif dir == 2 then
            for i = 1, math.min(length, size - x - 1), 1 do
                biomeMap[x + i][y] = Biome('water')
                if biomeMap[x + i][y - 1].name ~= 'water' and biomeMap[x + i][y - 1].name ~= 'mountain' then
                    biomeMap[x + i][y - 1] = Biome('beach')
                end if biomeMap[x + i][y + 1].name ~= 'water' and biomeMap[x + i][y + 1].name ~= 'mountain' then
                    biomeMap[x + i][y + 1] = Biome('beach')
                end
            end
            x = x + length
        elseif dir == 3 then
            for i = 1, math.min(length, size - y - 1), 1 do
                biomeMap[x][y + i] = Biome('water')
                if biomeMap[x - 1][y + i].name ~= 'water' and biomeMap[x - 1][y + i].name ~= 'mountain' then
                    biomeMap[x - 1][y + i] = Biome('beach')
                end if biomeMap[x + 1][y + i].name ~= 'water' and biomeMap[x + 1][y + i].name ~= 'mountain' then
                    biomeMap[x + 1][y + i] = Biome('beach')
                end
            end
            y = y + length
        elseif dir == 4 then
            for i = 1, math.min(length, x - 1), 1 do
                biomeMap[x - i][y] = Biome('water')
                if biomeMap[x - i][y - 1].name ~= 'water' and biomeMap[x - i][y - 1].name ~= 'mountain' then
                    biomeMap[x - i][y - 1] = Biome('beach')
                end if biomeMap[x - i][y + 1].name ~= 'water' and biomeMap[x - i][y + 1].name ~= 'mountain' then
                    biomeMap[x -  i][y + 1] = Biome('beach')
                end
            end
            x = x - length
        end

        for i = math.max(1, x - 1), math.min(size, x + 1), 1 do
            for j = math.max(1, y - 1), math.min(size, y + 1), 1 do
                if biomeMap[i][j].name ~= 'water' and biomeMap[i][j].name ~= 'desert' and biomeMap[i][j].name ~= 'mountain' then
                    biomeMap[i][j] = Biome('beach')
                end
            end
        end

        riverLength = riverLength - length

        --check if out of map or out of river to generate
        if x <= 1 or x >= size or y <= 1 or y >= size or riverLength <= 0 then
            break
        end

        -- change direction
        local backwardsDir = ((dir + 1) % 4) + 1
        dir = math.random(4)
        while dir == backwardsDir do
            dir = math.random(4)
        end
    end
end

function GenerateTiles(size, biomeMap, tileAnimators)
    local tileMap = {}

    for col = 1, size, 1 do
        tileMap[col] = {}
        for row = 1, size, 1 do
            local name = biomeMap[col][row]:getTile()
            if TILE_DEFS[name].animated then
                tileMap[col][row] = AnimatedTile(name, col, row, tileAnimators[name])
            else
                tileMap[col][row] = Tile(name, col, row)
            end
        end
    end

    return tileMap
end

function GenerateEdges(size, tiles)
    local edgeMap = {}
    
    for col = 1, size, 1 do
        edgeMap[col] = {}
        for row = 1, size, 1 do
            edgeMap[col][row] = {}
            -- check all 4 sides
            for i = 1, 4, 1 do
                local x, y = col + DIRECTION_COORDS[i][1], row + DIRECTION_COORDS[i][2]
                if x >= 1 and x <= size and y >= 1 and y <= size and tiles[x][y].name ~= tiles[col][row].name then
                    table.insert(edgeMap[col][row], i)
                end
            end
        end
    end

    return edgeMap
end
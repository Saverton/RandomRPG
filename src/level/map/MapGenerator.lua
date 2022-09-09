--[[
    Class that generates maps based on def tables found in generation_defs.lua
    @author Saverton
]]

MapGenerator = Class{}

function MapGenerator.generateMap(def, name)
    local size = def.size
    local structureMap = {}
    local biomeMap = MapGenerator.generateBiomes(def, size, structureMap)
    local tileMap = MapGenerator.generateTiles(biomeMap, size)
    local featureMap = MapGenerator.generateFeatures(biomeMap, size)
    MapGenerator.generateStructures(structureMap, biomeMap, tileMap, featureMap)

    return Map(name, size, TileMap(size, tileMap, biomeMap), featureMap, {})
end

function MapGenerator.generateBiomes(def, size, structureMap)
    local biomeMap = {}
    local numOfBiomes = math.random(def.minBiomes, def.maxBiomes)
    local numOfRivers = math.random(def.minRivers, def.maxRivers)
    local biomes = def.biomes

    -- fill with base biome by default
    for col = 1, size, 1 do
        biomeMap[col] = {}
        for row = 1, size, 1 do
            biomeMap[col][row] = Biome(def.baseBiome)
        end
    end

    -- generate sub-biomes at different locations and sizes
    for i = 1, numOfBiomes, 1 do
        local biomeSize = math.random(def.minBiomeSize, def.maxBiomeSize)
        local biomeType = biomes[math.random(#biomes)]
        local x, y= math.random(1, size - biomeSize), math.random(1, size - biomeSize)
        for col = x, x + biomeSize, 1 do
            for row = y, y + biomeSize, 1 do
                biomeMap[col][row] = Biome(biomeType)
            end
        end
    end

    -- generate water around edges and a river that cuts through the world
    if def.generateBorder then
        for i = 1, size, 1 do
            biomeMap[1][i] = Biome(def.borderBiome)
            biomeMap[i][size] = Biome(def.borderBiome)
            biomeMap[size][i] = Biome(def.borderBiome)
            biomeMap[i][1] = Biome(def.borderBiome)
        end
    end

    --generate rivers
    for i = 1, numOfRivers, 1 do
        GenerateRiver(biomeMap, size)
    end
    return biomeMap
end

function MapGenerator.generateTiles(biomeMap, size)
    local tileMap = {}

    for col = 1, size, 1 do
        tileMap[col] = {}
        for row = 1, size, 1 do
            tileMap[col][row] = Tile(biomeMap[col][row]:getTile(), col, row)
        end
    end

    return tileMap
end

function MapGenerator.generateFeatures(biomeMap, size)
    local featureMap = {}

    for col = 1, size, 1 do
        featureMap[col] = {}
        for row = 1, size, 1 do
            local biome = biomeMap[col][row]
            -- determine if we generate a feature in this tile
            if math.random() < BIOME_DEFS[biome.name].featProc then
                -- generate a feature
                local num = math.random()
                local sum = 0
                for i, feature in pairs(BIOME_DEFS[biome.name].features) do
                    sum = sum + feature.proc 
                    if num < sum then
                        if FEATURE_DEFS[feature.name].animated then
                            featureMap[col][row] = AnimatedFeature(feature.name, col, row, Animation(feature.name, 'main'))
                        else
                            featureMap[col][row] = Feature(feature.name, col, row)
                        end
                        break
                    end
                end
            end
        end
    end

    return featureMap
end

function MapGenerator.generateRiver(biomeMap, size)
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

function MapGenerator.generateEdges(size, tiles)
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

function MapGenerator.generateStructures(structureMap, biomeMap, tileMap, featureMap)
    for i, structure in pairs(structureMap) do
        local sdef = STRUCTURE_DEFS[structure.name]
        
        --set biomes
        if sdef.biome ~= nil then
            for x = structure.col, structure.col + sdef.width - 1, 1 do 
                for y = structure.row, structure.row + sdef.height - 1, 1 do
                    biomeMap[x][y] = Biome(sdef.biome)
                end
            end
        end

        -- set tiles
        if sdef.border_tile ~= nil or sdef.bottom_tile ~= nil then
            for x = structure.col - 1, structure.col + sdef.width, 1 do 
                for y = structure.row - 1, structure.row + sdef.height, 1 do
                    if sdef.border_tile ~= nil and (x == structure.col - 1 or x == structure.col + sdef.width or 
                    y == structure.row - 1 or y == structure.row + sdef.height) then
                        featureMap[x][y] = nil
                        tileMap[x][y] = Tile(sdef.border_tile, x, y)
                    elseif sdef.bottom_tile ~= nil then
                        tileMap[x][y] = Tile(sdef.bottom_tile, x, y)
                    end
                end
            end
        end

        --set features
        if sdef.layout ~= nil then
            for x = 1, sdef.width, 1 do 
                for y = 1, sdef.height, 1 do
                    local col = x + structure.col - 1
                    local row = y + structure.row - 1
                    featureMap[col][row] = nil
                    if (sdef.layout[x][y] ~= nil and sdef.layout[x][y] ~= 0) then
                        local feature = sdef.features[sdef.layout[x][y]]
                        if math.random() < feature.chance then
                            featureMap[col][row] = Feature(feature.name, col, row)
                        end
                    end
                end
            end
        end
    end
end
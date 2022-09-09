--[[
    Class that generates maps based on def tables found in generation_defs.lua
    @author Saverton
]]

MapGenerator = Class{}

function MapGenerator.generateMap(def, name, enterPos)
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
    local numOfPaths = math.random(def.minPaths, def.maxPaths)
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

    --generate paths
    for i = 1, numOfPaths, 1 do
        local start = def.start
        if def.structureAtStart ~= nil then
            table.insert(structureMap, {name = def.structureAtStart, col = start.x - math.floor(STRUCTURE_DEFS[def.structureAtStart]. width / 2), 
                row = start.y - math.floor(STRUCTURE_DEFS[def.structureAtStart].height / 2)})
        end
        MapGenerator.generatePath(biomeMap, size, def, start, structureMap)
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

function MapGenerator.generatePath(biomeMap, size, def, start, structureMap)
    local pathBiome = def.pathBiome
    local pathBorderBiome = def.pathBorderBiome
    if start == nil then
        start = {}
    end
    local pathLength = math.random(20, 50)
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
    local x = start.x or startDirection[choice].x
    local y = start.y or startDirection[choice].y
    local dir = start.dir or startDirection[choice].dir
    while true do
        local length = math.random(def.minPathSegment, def.maxPathSegment)
        local deltas = DIRECTION_COORDS_VARS[dir]
        for i = 1, length, 1 do
            local col = x + (deltas.x * i) 
            local row = y + (deltas.y * i)
            if col < 1 or col > size or row < 1 or row > size then
                break
            end
            biomeMap[col][row] = Biome(pathBiome)
            if deltas.x == 0 then
                if col - 1 > 1 then
                    biomeMap[col - 1][row] = Biome(pathBorderBiome)
                end
                if col + 1 < size then
                    biomeMap[col + 1][row] = Biome(pathBorderBiome)
                end
            elseif deltas.y == 0 then
                if row - 1 > 1 then
                    biomeMap[col][row - 1] = Biome(pathBorderBiome)
                end
                if row + 1 < size then
                    biomeMap[col][row + 1] = Biome(pathBorderBiome)
                end
            end
        end
        x = x + deltas.x * length
        y = y + deltas.y * length

        for i = math.max(1, x - 1), math.min(size, x + 1), 1 do
            for j = math.max(1, y - 1), math.min(size, y + 1), 1 do
                if biomeMap[i][j].name ~= pathBiome then
                    biomeMap[i][j] = Biome(pathBorderBiome)
                end
            end
        end

        if def.structureAtTurnChance ~= nil and math.random() < def.structureAtTurnChance then
            local structName = def.structures[math.random(#def.structures)]
            if STRUCTURE_DEFS[structName].width + x > size - 1 or STRUCTURE_DEFS[structName].height + y > size - 1 then
                goto skip
            end
            table.insert(structureMap, {name = structName, col = x - math.floor(STRUCTURE_DEFS[structName].width / 2), 
                row = y - math.floor(STRUCTURE_DEFS[structName].height / 2)})
        end
        ::skip::

        pathLength = pathLength - length

        --check if out of map or out of river to generate
        if x <= 1 or x >= size or y <= 1 or y >= size or pathLength <= 0 then
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
                    if Contains(sdef.keepTiles, tileMap[x][y].name) then
                        goto continue
                    end
                    if sdef.border_tile ~= nil and (x == structure.col - 1 or x == structure.col + sdef.width or 
                    y == structure.row - 1 or y == structure.row + sdef.height) then
                        featureMap[x][y] = nil
                        tileMap[x][y] = Tile(sdef.border_tile, x, y)
                    elseif sdef.bottom_tile ~= nil then
                        tileMap[x][y] = Tile(sdef.bottom_tile, x, y)
                    end
                    ::continue::
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
                    if (sdef.layout[x] ~= nil and sdef.layout[x][y] ~= nil and sdef.layout[x][y] ~= 0) then
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
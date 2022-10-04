--[[
    Overworld Generator: Class that generates overworld maps based on definition tables
    @author Saverton
]]

OverworldGenerator = Class{}

-- generate an overworld map
function OverworldGenerator.generateMap(definitions)
    local dimensions = {width = definitions.width, height = definitions.height} -- map dimensions
    local structureMap = {} -- empty structure map
    local biomeMap = OverworldGenerator.generateBiomes(definitions, dimensions) -- generate the world biomes
    local tileMap = OverworldGenerator.generateTiles(biomeMap, dimensions) -- generate tile map based on biomes
    local featureMap = OverworldGenerator.generateFeatures(biomeMap, dimensions) -- generate feature map based on biomes
    OverworldGenerator.generateStructures(structureMap, biomeMap, tileMap, featureMap) -- generate the structures determined into the map itself
    local gatewayMap = OverworldGenerator.generateGateways(definitions, dimensions, tileMap) -- mark positions to generate gateway features
    return OverworldMap(dimensions, {biomeMap = biomeMap, tileMap = tileMap, featureMap = featureMap, gatewayMap = gatewayMap})
end

-- generate biomes through spreading them from random starting positions, then dividing them with rivers
function OverworldGenerator.generateBiomes(definitions, dimensions)
    local biomeMap = OverworldGenerator.generateNewBiomeMap(dimensions, "empty")
    local numberOfBiomes = #definitions.biomes
    local divisionGrid = OverworldGenerator.createDivisionGrid(dimensions, numberOfBiomes) -- create a division grid
    local startBiomeList = {}
    for i, biome in ipairs(definitions.biomes) do -- place each biome in a square of the grid
        table.insert(startBiomeList, 
            {col = divisionGrid[i][math.random(1, numberOfBiomes)].x + math.random(0, divisionGrid[i][math.random(1, numberOfBiomes)].dimensions.width), 
            row = divisionGrid[i][math.random(1, numberOfBiomes)].x + math.random(0, divisionGrid[i][math.random(1, numberOfBiomes)].dimensions.height), 
            biome = biome}) -- add the biome starting squares
    end
    local biomeSpreader = BiomeSpreader(startBiomeList, biomeMap) -- spread each biome 
    biomeSpreader:runSpreader()
    OverworldGenerator.generateBorderBiome(biomeMap, definitions.borderBiome) -- place rivers between different biomes and water around the map border
    return biomeMap
end

-- fill a new biome map with a given biome
function OverworldGenerator.generateNewBiomeMap(dimensions, biomeName)
    local biomeMap = {}
    for col = 1, dimensions.width, 1 do
        biomeMap[col] = {}
        for row = 1, dimensions.height, 1 do
            biomeMap[col][row] = Biome(biomeName)
        end
    end
    return biomeMap
end

-- build border biomes between biomes of different types and around the edges
function OverworldGenerator.generateBorderBiome(biomeMap, borderBiome)
    for col = 1, #biomeMap, 1 do
        for row = 1, #biomeMap[col], 1 do
            local thisBiome = biomeMap[col][row].name
            if col == 1 or col == #biomeMap or row == 1 or row == #biomeMap[col] or thisBiome ~= biomeMap[col + 1][row].name 
                or thisBiome ~= biomeMap[col][row + 1].name or thisBiome ~= biomeMap[col + 1][row + 1].name then
                biomeMap[col][row] = Biome(borderBiome) -- if the biomes don't match with those to the right and below, place a border biome
            end
        end
    end
end

function OverworldGenerator.generatePath(biomeMap, dimensions, definitions)
    local pathBiome = definitions.pathBiome -- the biome that makes up the path itself
    local pathBorderBiome = definitions.pathBorderBiome -- the biome that borders the path
    local pathLength = math.random(definitions.minPathLength, definitions.maxPathLength) -- pick a length for the path
    local x, y = 0, 0 -- start position of path
    local direction = math.random(4) -- starting direction of the path
    if direction == 1 then
        x, y = math.random(1, dimensions.width), dimensions.height
    elseif direction == 2 then
        x, y = 1, math.random(1, dimensions.height)
    elseif direction == 3 then
        x, y = math.random(1, dimensions.width), 1
    elseif direction == 4 then
        x, y = dimensions.width, math.random(1, dimensions.height)
    end -- choose start position based on starting direction of the map
    while true do
        local length = math.random(definitions.minPathSegment, definitions.maxPathSegment) -- the length of this segment
        local deltas = DIRECTION_COORDS[direction] -- the deltas of x and y for this direction
        for i = 1, length, 1 do
            local col, row = x + (deltas.x * i), y + (deltas.y * i) -- x and y positions of path piece
            if col < 1 or col > dimensions.width or row < 1 or row > dimensions.height then
                break -- stop if we go out of the map
            end
            biomeMap[col][row] = Biome(pathBiome) -- set the pathbiome to this tile
            for borderX = math.max(1, col - 1), math.min(dimensions.width, col + 1), 1 do
                for borderY = math.max(1, row - 1), math.min(dimensions.height, row + 1), 1 do
                    if biomeMap[borderX][borderY].name ~= pathBiome then
                        biomeMap[borderX][borderY] = Biome(pathBorderBiome) -- set the border biome around
                    end
                end
            end
        end
        x, y = x + (deltas.x * length), y + (deltas.y * length) -- set the x and y positions to the new length
        pathLength = pathLength - length -- remove this segment's length from the total path length
        if x < 1 or x > dimensions.width or y < 1 or y > dimensions.height or pathLength <= 0 then 
            break -- stop if out of map or out of path to generate
        else
            -- otherwise, change direction
            local backwardsDirection = ((direction + 1) % 4) + 1 -- reference to the direction backwards to this one
            direction = math.random(4)
            while direction == backwardsDirection do
                direction = math.random(4) -- make sure the path doesn't turn directly around
            end
        end
    end
end

-- generate tiles according to the biomeMap
function OverworldGenerator.generateTiles(biomeMap, dimensions)
    local tileMap = {}
    for col = 1, dimensions.width, 1 do
        tileMap[col] = {}
        for row = 1, dimensions.height, 1 do
            tileMap[col][row] = Tile(biomeMap[col][row]:getTile()) -- get the tile to generate from the tile's biome
        end
    end
    return tileMap
end

-- generate features according to the biome
function OverworldGenerator.generateFeatures(biomeMap, dimensions)
    local featureMap = {} -- map that holds all features
    for col = 1, dimensions.width, 1 do
        featureMap[col] = {}
        for row = 1, dimensions.height, 1 do
            local biome = biomeMap[col][row]
            if math.random() < BIOME_DEFS[biome.name].featureChance then -- determine if we generate a feature in this tile
                local featureName = biome:getFeature() -- get a feature belonging to this biome
                local feature = Feature(featureName) -- feature to be added
                if FEATURE_DEFS[featureName].animated then
                    feature = AnimatedFeature(featureName, Animation(featureName, 'main')) -- set as animated feature if it should be animated
                end
                featureMap[col][row] = feature -- add the feature onto the map
            end
        end
    end
    return featureMap -- return completed map
end

-- generate edges for each tile on the map
function OverworldGenerator.generateEdgeMap(tileMap, dimensions)
    local edgeMap = {}
    local width, height = dimensions.width, dimensions.height -- get the width and height of the map
    for col = 1, width, 1 do
        edgeMap[col] = {}
        for row = 1, height, 1 do
            edgeMap[col][row] = {} -- set this edge location to empty by default
            for i = 1, 4, 1 do -- check all 4 sides to add an edge
                local x, y = col + DIRECTION_COORDS[i].x, row + DIRECTION_COORDS[i].y
                if x >= 1 and x <= width and y >= 1 and y <= height and tileMap[x][y].name ~= tileMap[col][row].name then
                    table.insert(edgeMap[col][row], i) -- add any edges that need adding
                end
            end
        end
    end
    return edgeMap -- return completed map
end

-- generate structures onto the map using the structure map
function OverworldGenerator.generateStructures(structureMap, biomeMap, tileMap, featureMap)
    for i, structure in pairs(structureMap) do
        local structureDefinitions = STRUCTURE_DEFS[structure.name] -- reference to structure's definitions table
        if structureDefinitions.biome ~= nil then
            for x = structure.col, structure.col + structureDefinitions.width - 1, 1 do 
                for y = structure.row, structure.row + structureDefinitions.height - 1, 1 do
                    biomeMap[x][y] = Biome(structureDefinitions.biome) -- set structure's biomes
                end
            end
        end
        if structureDefinitions.border_tile ~= nil or structureDefinitions.bottom_tile ~= nil then
            for x = structure.col - 1, structure.col + structureDefinitions.width, 1 do 
                for y = structure.row - 1, structure.row + structureDefinitions.height, 1 do -- set structure's tiles
                    if Contains(structureDefinitions.keepTiles, tileMap[x][y].name) then
                        goto continue -- if this tile is flagged as one to keep, don't override
                    end
                    if structureDefinitions.border_tile ~= nil and (x == structure.col - 1 or x == structure.col + structureDefinitions.width or 
                        y == structure.row - 1 or y == structure.row + structureDefinitions.height) then
                        featureMap[x][y] = nil -- build a structure border on outside tiles
                        tileMap[x][y] = Tile(structureDefinitions.border_tile)
                    elseif structureDefinitions.bottom_tile ~= nil then
                        tileMap[x][y] = Tile(structureDefinitions.bottom_tile)
                    end
                    ::continue::
                end
            end
        end
        if structureDefinitions.layouts ~= nil then -- check for a feature layout map
            local layout = LAYOUT_DEFS[structureDefinitions.layouts[math.random(#structureDefinitions.layouts)]] -- reference to the layout
            for x = 1, structureDefinitions.width, 1 do 
                for y = 1, structureDefinitions.height, 1 do
                    local col, row = x + structure.col - 1, y + structure.row - 1 -- set the location of this feature
                    featureMap[col][row] = nil -- remove any existing features
                    if (layout[y] ~= nil and layout[y][x] ~= nil and layout[y][x] ~= 0 and layout[y][x] <= #structureDefinitions.features) then
                        local feature = structureDefinitions.features[layout[y][x]] -- feature at this coordinate
                        if math.random() < feature.chance then -- determine if this feature generates based on its defined chance
                            if FEATURE_DEFS[feature.name].gateway then
                                featureMap[col][row] = GatewayFeature(feature.name, feature.destination)
                            elseif FEATURE_DEFS[feature.name].spawner then
                                featureMap[col][row] = SpawnFeature(feature.name, feature.enemy)
                            elseif FEATURE_DEFS[feature.name].animated then
                                featureMap[col][row] = AnimatedFeature(feature.name, Animation(feature.name, 'main'))
                            else
                                featureMap[col][row] = Feature(feature.name)
                            end -- spawn the appropriate feature
                        end
                    end
                end
            end
        end
    end
end

-- return a table with references to all animated features
function OverworldGenerator.getAnimatedFeatures(featureMap)
    local animatedFeatures = {}
    for i, col in pairs(featureMap) do
        for k, feature in pairs(col) do
            if FEATURE_DEFS[feature.name].animated then
                table.insert(animatedFeatures, feature) -- add any animated features to the table
            end
        end
    end
    return animatedFeatures -- return populated table
end

-- generate any gateways, in this case dungeons
function OverworldGenerator.generateGateways(definitions, dimensions, tileMap)
    local gateways = {} -- table of gateways
    local gatewayDivider = OverworldGenerator.createDivisionGrid(dimensions, #definitions.gateways)
    for i, gateway in ipairs(definitions.gateways) do -- go through each gateway that must be generated
        local location = gatewayDivider[math.random(#gatewayDivider)][math.random(#gatewayDivider)]
        while (location.filled) do
            location = gatewayDivider[math.random(#gatewayDivider)][math.random(#gatewayDivider)] -- set the divider that this feature will generate in
        end
        local spawnX, spawnY
        repeat
            spawnX, spawnY = math.random(location.x, location.x + location.dimensions.width), 
                math.random(location.y, location.y + location.dimensions.height) -- spawn x and y of the feature
        until not (spawnX <= 1 or spawnX >= dimensions.width or spawnY <= 1 or spawnY >= dimensions.height or tileMap[spawnX][spawnY] == 'water')
        table.insert(gateways, {name = gateway.name, x = spawnX, y = spawnY, destination = gateway.destination}) -- add the gateway feature
    end
    return gateways -- return the populated table
end

-- generate a set of invisible division marks across the map
function OverworldGenerator.createDivisionGrid(dimensions, numOfDividers)
    local dividers = {}
    for x = 1, numOfDividers, 1 do
        dividers[x] = {}
        for y = 1, numOfDividers, 1 do
            dividers[x][y] = {x = math.floor((dimensions.width / numOfDividers) * (x - 1)),
                y = math.floor((dimensions.height / numOfDividers) * (y - 1)), filled = false, 
                dimensions = {width = math.floor(dimensions.width / numOfDividers), 
                    height = math.floor(dimensions.height / numOfDividers)}} -- mark a portion of the map to generate a potential gateway feature
        end
    end
    return dividers
end
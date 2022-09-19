--[[
    Dungeon Generator class: generates a dungeon with a grid of rooms 
    @author Saverton
]]

DungeonGenerator = Class{}

function DungeonGenerator.generateDungeon(definitions, difficultyTable)
    local dungeonSize = difficultyTable.size + 2 -- size is min 3, max 5
    local dimensions = {width = (dungeonSize * ROOM_WIDTH) + 1, height = (dungeonSize * ROOM_HEIGHT) + 1} -- set width and height of map
    local dungeonGrid = DungeonGenerator.generateDunGrid(dungeonSize) -- create grid of rooms
    local landmarks = DungeonGenerator.generateRooms(definitions, dungeonGrid, dungeonSize, difficultyTable) -- generate rooms, return a table with the starting and ending x and y
    local tileMap, featureMap = DungeonGenerator.generateFill(definitions, dimensions) -- generate the tiles and features of the dungeon
    DungeonGenerator.generateStructures(DungeonGenerator.getStructureMap(dungeonGrid), tileMap, featureMap, difficultyTable) -- generate the structures of the dungeon (rooms)
    DungeonGenerator.generatePath(dungeonGrid, landmarks, definitions, tileMap, featureMap) -- generate a path through the dungeon
    DungeonGenerator.removeDeadRooms(dungeonGrid, definitions, tileMap, featureMap) -- remove any rooms that do not have access via paths
    return DungeonMap(dimensions, {tileMap = tileMap, featureMap = featureMap, gatewayMap = {}, start = {
        x = ((landmarks.startX - 1) * ROOM_WIDTH) + (ROOM_WIDTH / 2 + 1), y =  ((landmarks.startY - 1) * ROOM_HEIGHT) + (ROOM_HEIGHT / 2 + 1),
        color = ENEMY_COLORS[difficultyTable.color]
    }}) -- create a new dungeon map
end

-- create a grid of empty rooms in the dungeonGrid
function DungeonGenerator.generateDunGrid(dungeonSize)
    local dungeonGrid = {}
    for x = 1, dungeonSize, 1 do
        dungeonGrid[x] = {}
        for y = 1, dungeonSize, 1 do
            dungeonGrid[x][y] = {
                room = nil,
                access = false
            } -- create an empty room slot
        end
    end
    return dungeonGrid
end

-- generate the rooms that will be placed in the dungeon
function DungeonGenerator.generateRooms(definitions, dungeonGrid, dungeonSize, difficultyTable)
    local startX, startY, endX, endY = 1, 1, 1, 1
    while startX == endX or startY == endY do
        startX, startY, endX, endY = math.random(dungeonSize), math.random(dungeonSize), math.random(dungeonSize), math.random(dungeonSize)
    end -- choose the start and end room positions
    local landmarks = {startX = startX, startY = startY, endX = endX, endY = endY}
    for x = 1, dungeonSize, 1 do
        for y = 1, dungeonSize, 1 do
            local name = DungeonGenerator.getRoom(definitions.rooms, difficultyTable) -- choose a room name
            local col, row = ((x - 1) * ROOM_WIDTH) + ((ROOM_WIDTH / 2 + 1) - math.floor(STRUCTURE_DEFS[name].width / 2)),
                ((y - 1) * ROOM_HEIGHT) + ((ROOM_HEIGHT / 2 + 1) - math.floor(STRUCTURE_DEFS[name].height / 2)) -- define tile coordinates for the room
            dungeonGrid[x][y].room = {name = name, col = col, row = row} -- set the room
        end
    end
    local startRoom = DungeonGenerator.getRoom(definitions.startRooms, difficultyTable)
    dungeonGrid[startX][startY] = {room = {name = startRoom, 
        col = ((startX - 1) * ROOM_WIDTH) + ((ROOM_WIDTH / 2 + 1) - math.floor(STRUCTURE_DEFS[startRoom].width / 2)),
        row = ((startY - 1) * ROOM_HEIGHT) + ((ROOM_HEIGHT / 2 + 1) - math.floor(STRUCTURE_DEFS[startRoom].height / 2))}, access = true}
        -- create the start room flag as accessible
    local endRoom = DungeonGenerator.getRoom(definitions.endRooms, difficultyTable)
    dungeonGrid[endX][endY] = {room = {name = endRoom, 
        col = ((endX - 1) * ROOM_WIDTH) + ((ROOM_WIDTH / 2 + 1) - math.floor(STRUCTURE_DEFS[endRoom].width / 2)),
        row = ((endY - 1) * ROOM_HEIGHT) + ((ROOM_HEIGHT / 2 + 1) - math.floor(STRUCTURE_DEFS[endRoom].height / 2))}, access = true}
        -- create the end room, flag as accessible
    return landmarks -- the list containing the starting and ending room x and y positions on the dungeon grid
end

-- generate spaces for features and fill tiles with the default inside wall tile
function DungeonGenerator.generateFill(definitions, dimensions)
    local tileMap, featureMap = {}, {}
    for x = 1, dimensions.width, 1 do
        tileMap[x] = {}
        featureMap[x] = {}
        for y = 1, dimensions.height, 1 do
            tileMap[x][y] = Tile(definitions.insideTile) -- set tile to inside wall
            featureMap[x][y] = nil -- set feature to empty
        end
    end
    return tileMap, featureMap -- return the updated tile and feature map
end

-- create a structure map using the dungeon grid and room needs
function DungeonGenerator.getStructureMap(dungeonGrid)
    local structureMap = {}
    for x, col in ipairs(dungeonGrid) do
        for y, space in ipairs(col) do
            table.insert(structureMap, space.room) -- add structures for each room
        end
    end
    return structureMap
end

-- generate a path through the dungeon that connects the start room to the end room.
function DungeonGenerator.generatePath(dungeonGrid, landmarks, definitions, tileMap, featureMap)
    local startX, startY, finishX, finishY = ((landmarks.startX - 1) * ROOM_WIDTH) + (ROOM_WIDTH / 2 + 1), ((landmarks.startY - 1) * ROOM_HEIGHT) + (ROOM_HEIGHT / 2 + 1), 
        ((landmarks.endX - 1) * ROOM_WIDTH) + (ROOM_WIDTH / 2 + 1), ((landmarks.endY - 1) * ROOM_HEIGHT) + (ROOM_HEIGHT / 2 + 1) -- start and finish locations of the dungeon
    local x, y = startX, startY -- set the starting x and y for the path
    local dungeonX, dungeonY = landmarks.startX, landmarks.startY -- set starting dungeon grid coordinates
    while x ~= finishX or y ~= finishY do
        local dir = math.random(4)  -- pick a random direction
        local spawnKeyDoor = math.random(4) == 1 -- 1 / 4 chance to spawn key door
        local potentialDungeonX, potentialDungeonY = dungeonX + DIRECTION_COORDS[dir].x, dungeonY + DIRECTION_COORDS[dir].y
        while (potentialDungeonX < 1 or potentialDungeonX > #dungeonGrid or potentialDungeonY < 1 or potentialDungeonY > #dungeonGrid) or 
            (math.random() < 0.75 and dungeonGrid[potentialDungeonX][potentialDungeonY].access) do -- keep changng direction until result is in the map
            dir = math.random(4)
            potentialDungeonX, potentialDungeonY = dungeonX + DIRECTION_COORDS[dir].x, dungeonY + DIRECTION_COORDS[dir].y
        end
        dungeonX, dungeonY = dungeonX + DIRECTION_COORDS[dir].x, dungeonY + DIRECTION_COORDS[dir].y -- set new dungeon coordinates
        dungeonGrid[dungeonX][dungeonY].access = true -- set this room as accessible
        for i = 1, math.abs(DIRECTION_COORDS[dir].x * ROOM_WIDTH) + math.abs(DIRECTION_COORDS[dir].y * ROOM_HEIGHT), 1 do
            local carveX, carveY = x + (DIRECTION_COORDS[dir].x * i), y + (DIRECTION_COORDS[dir].y * i) -- carve out a path to this new room
            if spawnKeyDoor and tileMap[carveX][carveY].name == definitions.wallTile then
                featureMap[carveX][carveY] = Feature('key_door') -- spawn a key door in the passage
                spawnKeyDoor = false -- stop spawning key doors
            end
            tileMap[carveX][carveY] = Tile(definitions.floorTile)
            for borderX = carveX - 1, carveX + 1, 1 do
                for borderY = carveY - 1, carveY + 1, 1 do
                    if tileMap[borderX][borderY].name == definitions.insideTile then
                        tileMap[borderX][borderY] = Tile(definitions.pathBorderTile) -- replace any inside tiles with border tiles around path.
                    end
                end
            end
        end
        x, y = x + (DIRECTION_COORDS[dir].x * ROOM_WIDTH), y + (DIRECTION_COORDS[dir].y * ROOM_HEIGHT)
            -- set x and y position of path to new x and y of room center
    end
end

-- remove any rooms that are not accessible using the path
function DungeonGenerator.removeDeadRooms(dungeonGrid, definitions, tileMap, featureMap)
    for x, col in ipairs(dungeonGrid) do
        for y, space in ipairs(col) do
            if not space.access then -- check if room has access
                for rx = ((x - 1) * ROOM_WIDTH) + 1, ((x - 1) * ROOM_WIDTH) + ROOM_WIDTH, 1 do
                    for ry = ((y - 1) * ROOM_HEIGHT) + 1, ((y - 1) *  ROOM_HEIGHT) + ROOM_HEIGHT, 1 do
                        tileMap[rx][ry] = Tile(definitions.insideTile) -- fill room with inside tile
                        featureMap[rx][ry] = nil -- remove all features
                    end
                end
            end
        end
    end
end

-- generate structures onto the map using the structure map
function DungeonGenerator.generateStructures(structureMap, tileMap, featureMap, difficultyTable)
    for i, structure in pairs(structureMap) do
        local structureDefinitions = STRUCTURE_DEFS[structure.name] -- reference to structure's definitions table
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
            local layout = LAYOUT_DEFS[DungeonGenerator.getLayout(structureDefinitions.layouts, difficultyTable)] -- reference to the layout
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

-- return a room name that is taken based on the difficulty and the generation definitions
function DungeonGenerator.getRoom(rooms, difficultyTable)
    local resultRoomTable = rooms[math.min(math.random(difficultyTable.room), #rooms)]
    return resultRoomTable[math.random(#resultRoomTable)] -- return the resulting room
end

-- return a layout that is taken based on the difficulty and the room definition
function DungeonGenerator.getLayout(layouts, difficultyTable)
    local resultLayoutTable = layouts[math.min(math.random(difficultyTable.layout), #layouts)]
    return resultLayoutTable[math.random(#resultLayoutTable)] -- return resulting layout
end
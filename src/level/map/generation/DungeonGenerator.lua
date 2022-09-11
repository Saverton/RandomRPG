--[[
    Dungeon Generator class: generates a dungeon based on my super secret process!!!
    @author Saverton
]]

DungeonGenerator = Class{}

function DungeonGenerator.generateDungeon(def, dunSize, name)
    local size = (dunSize * 10) + 1
    local dunGrid = DungeonGenerator.generateDunGrid(dunSize)
    local landmarks = DungeonGenerator.generateRooms(def, dunGrid, dunSize)
    local biomeMap, tileMap, featureMap = DungeonGenerator.generateFill(def, size)
    MapGenerator.generateStructures(DungeonGenerator.getStructureMap(dunGrid), biomeMap, tileMap, featureMap)
    DungeonGenerator.generatePath(dunGrid, landmarks, def, tileMap, size)
    DungeonGenerator.removeDeadRooms(dunGrid, def, tileMap, featureMap)

    return Map(name, size, tileMap, biomeMap, featureMap, {})
end

function DungeonGenerator.generateDunGrid(dunSize)
    local dunGrid = {}
    for x = 1, dunSize, 1 do
        dunGrid[x] = {}
        for y = 1, dunSize, 1 do
            dunGrid[x][y] = {
                room = nil,
                access = false
            }
        end
    end
    return dunGrid
end

function DungeonGenerator.generateRooms(def, dunGrid, dunSize)
    local startX, startY, endX, endY = 1, 1, 1, 1
    while startX == endX or startY == endY do
        startX, startY, endX, endY = math.random(dunSize), math.random(dunSize), math.random(dunSize), math.random(dunSize)
    end
    local landmarks = {sx = startX, sy = startY, ex = endX, ey = endY}
    for x = 1, dunSize, 1 do
        for y = 1, dunSize, 1 do
            local name = def.rooms[math.random(#def.rooms)]
            dunGrid[x][y].room = {name = name, col = ((x - 1) * 10) + (6 - math.floor(STRUCTURE_DEFS[name].width / 2)),
                row = ((y - 1) * 10) + (6 - math.floor(STRUCTURE_DEFS[name].height / 2))}
        end
    end
    dunGrid[startX][startY].room = {name = def.startRoom, col = ((startX - 1) * 10) + (6 - math.floor(STRUCTURE_DEFS[def.startRoom].width / 2)),
    row = ((startY - 1) * 10) + (6 - math.floor(STRUCTURE_DEFS[def.startRoom].height / 2))}
    dunGrid[endX][endY].room = {name = def.endRoom, col = ((endX - 1) * 10) + (6 - math.floor(STRUCTURE_DEFS[def.endRoom].width / 2)),
    row = ((endY - 1) * 10) + (6 - math.floor(STRUCTURE_DEFS[def.endRoom].height / 2))}
    return landmarks
end

function DungeonGenerator.generateFill(def, size)
    local biomeMap, tileMap, featureMap = {}, {}, {}
    for x = 1, size, 1 do
        biomeMap[x] = {}
        tileMap[x] = {}
        featureMap[x] = {}
        for y = 1, size, 1 do
            biomeMap[x][y] = Biome(def.baseBiome)
            tileMap[x][y] = Tile(biomeMap[x][y]:getTile())
            featureMap[x][y] = nil
        end
    end
    return biomeMap, tileMap, featureMap
end

function DungeonGenerator.getStructureMap(dunGrid)
    local structureMap = {}
    for x, col in ipairs(dunGrid) do
        for y, space in ipairs(col) do
            table.insert(structureMap, space.room)
        end
    end
    return structureMap
end

function DungeonGenerator.generatePath(dunGrid, landmarks, def, tileMap, size)
    local staX, staY, finX, finY = ((landmarks.sx - 1) * 10) + 6, ((landmarks.sy - 1) * 10) + 6, ((landmarks.ex - 1) * 10) + 6, ((landmarks.ey - 1) * 10) + 6
    local x, y = staX, staY
    local dunX, dunY = landmarks.sx, landmarks.sy
    while x ~= finX or y ~= finY do
        -- pick a random direction
        local dir = math.random(4)
        -- check and see if the destination is in the map.
        local px, py = x + (DIRECTION_COORDS[dir].x * 10), y + (DIRECTION_COORDS[dir].y * 10)
        while px < 1 or px > size or py < 1 or py > size do
            dir = math.random(4)
            px, py = x + (DIRECTION_COORDS[dir].x * 10), y + (DIRECTION_COORDS[dir].y * 10)
        end
        -- set new dungeon coordinates
        dunX, dunY = dunX + DIRECTION_COORDS[dir].x, dunY + DIRECTION_COORDS[dir].y
        dunGrid[dunX][dunY].access = true
        -- carve out a path in this direction
        for i = 1, 10, 1 do
            local cx, cy = x + (DIRECTION_COORDS[dir].x * i), y + (DIRECTION_COORDS[dir].y * i)
            tileMap[cx][cy] = Tile(def.floorTile)
            for lx = cx - 1, cx + 1, 1 do
                for ly = cy - 1, cy + 1, 1 do
                    if tileMap[lx][ly] == def.insideTile then
                        tileMap[lx][ly] = def.pathBorderTile
                    end
                end
            end
        end
        x, y = x + (DIRECTION_COORDS[dir].x * 10), y + (DIRECTION_COORDS[dir].y * 10)
    end
end

function DungeonGenerator.removeDeadRooms(dunGrid, def, tileMap, featureMap)
    for x, col in ipairs(dunGrid) do
        for y, space in ipairs(col) do
            if not space.access then
                for rx = ((x - 1) * 10) + 1, ((x - 1) * 10) + 10, 1 do
                    for ry = ((y - 1) * 10) + 1, ((y - 1) *  10) + 10, 1 do
                        tileMap[rx][ry] = Tile(def.insideTile)
                        featureMap[rx][ry] = nil
                    end
                end
            end
        end
    end
end
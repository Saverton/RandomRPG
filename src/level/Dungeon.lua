--[[
    Dungeon Class: Inherited from the Level class, manages all activity within a playable level. Differences from Overworld: Uses Dungeon Map,
    spawns player at a specified start location, spawns enemies with spawner features, doesn't have an npc manager, uses DungeonCamera.
    @author Saverton.
]]

Dungeon = Class{__includes = Level}

function Dungeon:init(worldName, levelName, definitions)
    Level.init(self, worldName, levelName, definitions) -- initiate a level
    self.map = definitions.map or DungeonGenerator.generateDungeon(LEVEL_DEFS['dungeon'], self:getDifficulty(levelName)) -- carries and manages all data for the level's map (tiles, features)
    self:spawnPlayer(definitions.player or {}) -- initiate, set stateMachine, and spawn in the player
    self.camera = DungeonCamera(self.player, self, self:getCurrentRoom()) -- create a dungeon camera with a reference to the player as its target and this level.
    self.entityManager = EntityManager(self, definitions.entityManager or {}, 'dungeon')
        -- initiate an entityManager with a reference to this class, the entities that are loaded in or an empty set of entities, and the spawning type.
end

-- initiate player, spawn it at the designated spawn space
function Dungeon:spawnPlayer(definitions)
    Level.spawnPlayer(self, definitions)
    self.player:setPosition({x = self.map.start.x, y = self.map.start.y, xOffset = PLAYER_SPAWN_X_OFFSET, yOffset = PLAYER_SPAWN_Y_OFFSET}) 
        -- set the player's new position
end

-- return a table with the difficulty values for size, rooms, and layouts
function Dungeon:getDifficulty(levelName)
    local overallDifficulty = ((tonumber(string.sub(levelName, string.find(levelName, "-") + 1, string.len(levelName))) - 1) * 2) + 3
        -- get the difficulty based on the level name
    local difficultyTable = {0, 0, 0} -- default table with difficulty values
    while SumTable(difficultyTable) ~= overallDifficulty do
        difficultyTable = {math.random(3), math.random(3), math.random(3)} -- randomize difficulties until matches overall
    end
    return {size = difficultyTable[1], room = difficultyTable[2], layout = difficultyTable[3], color = overallDifficulty}
end

-- return the room coordinates of the current room that the player is in
function Dungeon:getCurrentRoom()
    return {x = math.floor(self.player.x / (ROOM_WIDTH * TILE_SIZE)), y = math.floor(self.player.y / (ROOM_HEIGHT * TILE_SIZE))}
end
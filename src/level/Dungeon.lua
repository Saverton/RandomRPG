--[[
    Dungeon Class: Inherited from the Level class, manages all activity within a playable level. Differences from Overworld: Uses Dungeon Map,
    spawns player at a specified start location, spawns enemies with spawner features, doesn't have an npc manager, uses DungeonCamera.
    @author Saverton.
]]

Dungeon = Class{__includes = Level}

function Dungeon:init(worldName, levelName, definitions)
    Level.init(self, worldName, levelName, definitions) -- initiate a level
    self.map = DungeonMap() -- carries and manages all data for the level's map (tiles, features)
    self.player = self:spawnPlayer(definitions.player or {}) -- initiate, set stateMachine, and spawn in the player
    self.entityManager = EntityManager(self, definitions.entityManager or {}, 'dungeon') 
        -- initiate an entityManager with a reference to this class, the entities that are loaded in or an empty set of entities, and the spawning type.
    self.camera = DungeonCamera(self.player, self) -- create a dungeon camera with a reference to the player as its target and this level.
end

-- initiate player, spawn it at the designated spawn space
function Dungeon:spawnPlayer(definitions)
    Level.spawnPlayer(self, definitions)
    self.player.x, self.player.y = (self.map.start.x - 1) * TILE_SIZE, (self.map.start.y - 1) * TILE_SIZE
end
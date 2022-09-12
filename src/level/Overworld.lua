--[[
    Overworld Class: Inherited from Level class, manages all activity in a playable level. Differences from Dungeon: uses Overworld Map,
    player spawns randomly if not given a spawn location, enemies spawn according to biomes, has an NPC manager, uses regular Camera.
    @author Saverton
]]

Overworld = Class{__includes = Level}

function Overworld:init(worldName, levelName, definitions)
    Level.init(self, worldName, levelName, definitions) -- initiate a level
    self.map = OverworldMap() -- carries and manages all data for the level's map (biomes, tiles, features)
    self.player = self:spawnPlayer(definitions) -- initiate, set stateMachine, and spawn a player.
    self.entityManager = EntityManager(self, definitions.entityManager or {}, 'overworld')
        -- initiate an entityManager with a reference to this class, the entities that are loaded in or an empty set of entities, and the spawning type.
    self.npcManager = NPCManager(self, definitions.npcs or {}) -- initiate an NPC Manager with a list of loaded npcs.
    self.camera = Camera(self.player, self) -- initiate a camera with a reference to its target, the player, and this level.
end

-- update each of the level's components
function Overworld:update(dt)
    Level.update(self, dt) 
    self.npcManager:update(dt)
end

-- render each of the level's components
function Overworld:render()
    Level.render(self) 
    self.npcManager:render(self.camera)
end
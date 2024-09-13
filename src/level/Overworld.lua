--[[
    Overworld Class: Inherited from Level class, manages all activity in a playable level. Differences from Dungeon: uses Overworld Map,
    player spawns randomly if not given a spawn location, enemies spawn according to biomes, has an NPC manager, uses regular Camera.
    @author Saverton
]]

Overworld = Class{__includes = Level}

function Overworld:init(worldName, levelName, definitions)
    Level.init(self, worldName, levelName, definitions) -- initiate a level
    self.map = definitions.map or OverworldGenerator.generateMap(LEVEL_DEFS['overworld']) -- carries and manages all data for the level's map (biomes, tiles, features)
    self:spawnPlayer(definitions.player) -- initiate, set stateMachine, and spawn a player.
    self.entityManager = EntityManager(self, definitions.entityManager or {}, 'overworld')
        -- initiate an entityManager with a reference to this class, the entities that are loaded in or an empty set of entities, and the spawning type.
    self.npcManager = NPCManager(self, definitions.npcs or {}) -- initiate an NPC Manager with a list of loaded npcs.
    self.camera = Camera(self.player, self) -- initiate a camera with a reference to its target, the player, and this level.
end

function Overworld:update(dt)
    Level.update(self, dt)
    self.npcManager:update(dt)
end

function Overworld:render()
    self.map:render(self.camera)
    self.pickupManager:render(self.camera)
    self.entityManager:render(self.camera)
    self.npcManager:render(self.camera)
    self.player:render(self.camera)
end

function Overworld:spawnPlayer(playerDefinitions)
    Level.spawnPlayer(self, playerDefinitions)
    local position = nil
    if ((playerDefinitions or {}).position ~= nil) then
        self:getPlayerSpawnPosition(playerDefinitions.position)
        position = playerDefinitions.position
    else
        local col, row = self.map:getSpawnableCoord() -- spawnable coordiante to place player
        position = {x = col, y = row, xOffset = PLAYER_SPAWN_X_OFFSET, yOffset = PLAYER_SPAWN_Y_OFFSET}
    end
    self.player:setPosition(position) -- set the player's position
end

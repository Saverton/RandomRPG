--[[
    Level class: combines all elements of a level (map, entities, player, camera, etc.)
    attributes: map, entities, player, camera
    @author Saverton
]]

Level = Class{}

function Level:init(worldName, levelName, definitions)
    self.worldName = worldName -- reference to the world's name
    self.levelName = levelName -- the name of the folder in which this level's data is stored, format <level_type>-<level_number>
    self.pickupManager = PickupManager(self, definitions.pickups) -- initiate a pickupManager with a reference to this class and any pickups that are loaded in.
    self.flags = {} -- used to track thrown flags by actions in the Level.
end

-- update each of the level's components
function Level:update(dt)
    self.map:update(dt)
    self.entityManager:update(dt)
    self.pickupManager:update(dt)
    self.player:update(dt)
    self.camera:update()
    self:updateFlags()
end

-- render each of the level's components based on the camera
function Level:render()
    self.map:render(self.camera)
    self.pickupManager:render(self.camera)
    self.entityManager:render(self.camera)
    self.player:render(self.camera)
end

-- Initiate the player
function Level:spawnPlayer(playerDefinitions)
    local position = {x = 1, y = 1, xOffset = PLAYER_SPAWN_X_OFFSET, yOffset = PLAYER_SPAWN_Y_OFFSET}
    self.player = Player(self, (playerDefinitions or {}).definitions or ENTITY_DEFS['player'], position)
end

-- throw a list of flags into the level's tracker that are checked at the end of the update cycle
function Level:throwFlags(flags)
    for i, flag in pairs(flags) do
        table.insert(self.flags, flag)
    end
end

-- send any flags to the player, reset the flags table
function Level:updateFlags()
    self.player.questManager:updateFlags(self.flags)
    self.flags = {}
end

-- get player position (used to prevent player spawning on top of a feature when coming out of an exit)
function Level:getPlayerSpawnPosition(position)
    for x = position.x, position.x + 2, 1 do
        for y = position.y, position.y + 2 do
            if self.map:isSpawnableSpace(x, y) then
                position.x, position.y = x, y -- new position of player
                return
            end
        end
    end
end

-- start playing background music on loop
function Level:playMusic()
    gSounds['music'][self.backgroundMusic]:setLooping(true) 
    gSounds['music'][self.backgroundMusic]:play()
end

-- pause the music
function Level:pauseMusic()
    gSounds['music'][self.backgroundMusic]:pause()
end

-- stop playing music
function Level:stopMusic()
    gSounds['music'][self.backgroundMusic]:stop()
end
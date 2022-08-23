--
-- libraries for base Love2D project
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

require 'src/states/BaseState'
require 'src/states/StateStack'

require 'src/states/game/StartState.lua'
require 'src/states/game/WorldState.lua'

require 'src/states/entity/player/PlayerIdleState.lua'
require 'src/states/entity/player/PlayerWalkState.lua'

require 'src/level/map/defs/biome_defs.lua'
require 'src/level/map/defs/feature_defs.lua'
require 'src/level/map/defs/tile_defs.lua'

require 'src/level/map/Biome.lua'
require 'src/level/map/Feature.lua'
require 'src/level/map/FeatureGenerator.lua'
require 'src/level/map/Map.lua' 
require 'src/level/map/Tile.lua' 
require 'src/level/map/TileMap.lua' 
require 'src/level/map/TileMapGenerator.lua' 

require 'src/level/entity/Enemy.lua'
require 'src/level/entity/Entity.lua' 
require 'src/level/entity/EntitySpawner.lua' 
require 'src/level/entity/NPC.lua' 
require 'src/level/entity/Object.lua' 
require 'src/level/entity/Player.lua' 
require 'src/level/entity/entity_defs.lua'

gTextures = {
    ['player'] = love.graphics.newImage('graphics/entities/character.png')
}

gFrames = {
    ['player'] = GenerateQuads(gTextures['player'], 16, 16)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}

gSounds = {
    
}
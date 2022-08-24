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

require 'src/states/game/StartState'
require 'src/states/game/WorldState'

require 'src/states/entity/EntityBaseState' 
require 'src/states/entity/EntityIdleState' 
require 'src/states/entity/EntityWalkState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerWalkState'

require 'src/level/Level' 
require 'src/level/Camera'

require 'src/level/map/defs/biome_defs'
require 'src/level/map/defs/feature_defs'
require 'src/level/map/defs/tile_defs'

require 'src/level/map/Biome'
require 'src/level/map/Feature'
require 'src/level/map/FeatureGenerator'
require 'src/level/map/Map' 
require 'src/level/map/Tile' 
require 'src/level/map/TileMap' 
require 'src/level/map/TileMapGenerator'

require 'src/level/entity/Enemy'
require 'src/level/entity/Entity' 
require 'src/level/entity/EntitySpawner' 
require 'src/level/entity/NPC' 
require 'src/level/entity/Object' 
require 'src/level/entity/Player' 
require 'src/level/entity/entity_defs'

gTextures = {
    ['player'] = love.graphics.newImage('graphics/entities/character.png'),
    ['tiles'] = love.graphics.newImage('graphics/map/tiles.png'),
    ['features'] = love.graphics.newImage('graphics/map/features.png')
}

gFrames = {
    ['player'] = GenerateQuads(gTextures['player'], 16, 16),
    ['tiles'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
    ['features'] = GenerateQuads(gTextures['features'], FEATURE_SIZE, FEATURE_SIZE)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}

gSounds = {
    
}
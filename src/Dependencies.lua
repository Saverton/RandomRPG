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
require 'src/states/game/GameOverState'
require 'src/states/game/DialogueState'
require 'src/states/game/MenuState'
require 'src/states/game/InventoryState'

require 'src/states/entity/EntityBaseState' 
require 'src/states/entity/EntityIdleState' 
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/EntityInteractState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerWalkState'

require 'src/states/entity/enemy/EnemyIdleState'
require 'src/states/entity/enemy/EnemyWalkState'

require 'src/states/entity/npc/NPCIdleState' 
require 'src/states/entity/npc/NPCWalkState'

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

require 'src/level/entity/Entity' 
require 'src/level/entity/CombatEntity'
require 'src/level/entity/entity_defs'
require 'src/level/entity/Player' 
require 'src/level/entity/EnemySpawner'
require 'src/level/entity/Enemy'
require 'src/level/entity/Effect'
require 'src/level/entity/effect_defs'
require 'src/level/entity/NPC'
require 'src/level/entity/NPCManager'

require 'src/level/entity/projectile/projectile_defs'
require 'src/level/entity/projectile/Projectile'

require 'src/level/entity/item/item_defs'
require 'src/level/entity/item/Item'
require 'src/level/entity/item/Weapon'
require 'src/level/entity/item/Pickup'
require 'src/level/entity/item/PickupManager'

require 'src/gui/Panel'
require 'src/gui/Textbox'
require 'src/gui/Selection'
require 'src/gui/Menu'
require 'src/gui/menu_defs'
require 'src/gui/OrderMenu'
require 'src/gui/Imagebox'
require 'src/gui/ProgressBar'

gTextures = {
    ['player'] = love.graphics.newImage('graphics/entities/character.png'),
    ['tiles'] = love.graphics.newImage('graphics/map/tiles.png'),
    ['features'] = love.graphics.newImage('graphics/map/features.png'),
    ['goblin'] = love.graphics.newImage('graphics/entities/goblin.png'),
    ['sword'] = love.graphics.newImage('graphics/entities/projectiles/sword.png'),
    ['bow'] = love.graphics.newImage('graphics/entities/projectiles/bow.png'),
    ['arrow'] = love.graphics.newImage('graphics/entities/projectiles/arrow.png'),
    ['tome'] = love.graphics.newImage('graphics/entities/projectiles/tome.png'),
    ['fireball'] = love.graphics.newImage('graphics/entities/projectiles/fireball.png'),
    ['effects'] = love.graphics.newImage('graphics/effects/effects.png'),
    ['items'] = love.graphics.newImage('graphics/items/items.png'),
    ['edges'] = love.graphics.newImage('graphics/map/edges.png'),
    ['npc'] = love.graphics.newImage('graphics/entities/npc.png')
}

gFrames = {
    ['player'] = GenerateQuads(gTextures['player'], 16, 16),
    ['tiles'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
    ['features'] = GenerateQuads(gTextures['features'], FEATURE_SIZE, FEATURE_SIZE),
    ['goblin'] = GenerateQuads(gTextures['goblin'], 16, 16),
    ['sword'] = GenerateQuads(gTextures['sword'], 16, 16),
    ['bow'] = GenerateQuads(gTextures['bow'], 16, 16),
    ['arrow'] = GenerateQuads(gTextures['arrow'], 16, 16),
    ['effects'] = GenerateQuads(gTextures['effects'], 8, 8),
    ['items'] = GenerateQuads(gTextures['items'], 16, 16),
    ['tome'] = GenerateQuads(gTextures['tome'], 16, 16),
    ['fireball'] = GenerateQuads(gTextures['fireball'], 16, 16),
    ['edges'] = GenerateQuads(gTextures['edges'], 16, 16),
    ['npc'] = GenerateQuads(gTextures['npc'], 16, 16)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}

gSounds = {
    ['menu_blip_1'] = love.audio.newSource('sounds/menu_blip_1.wav', 'static'),
    ['menu_select_1'] = love.audio.newSource('sounds/menu_select_1.wav', 'static'),
    ['hit_1'] = love.audio.newSource('sounds/hit_1.wav', 'static'),
    ['sword_swing_1'] = love.audio.newSource('sounds/sword_swing_1.wav', 'static'),
    ['player_dies_1'] = love.audio.newSource('sounds/player_dies_1.wav', 'static'),
    ['enemy_dies_1'] = love.audio.newSource('sounds/enemy_dies_1.wav', 'static'),
    ['fire_hit_1'] = love.audio.newSource('sounds/fire_hit_1.wav', 'static'),
    ['pickup_item'] = love.audio.newSource('sounds/pickup_item.wav', 'static')
}
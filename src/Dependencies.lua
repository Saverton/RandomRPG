--
-- libraries for base Love2D project
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'
Serialize = require 'lib/knife.serialize'

require 'src/constants'
require 'src/Util'

require 'src/animation/Animation'
require 'src/animation/animation_defs'

require 'src/states/StateMachine'
require 'src/states/BaseState'
require 'src/states/StateStack'

require 'src/states/game/StartState'
require 'src/states/game/CreateWorldState'
require 'src/states/game/WorldState'
require 'src/states/game/GameOverState'
require 'src/states/game/gui/DialogueState'
require 'src/states/game/gui/MenuState'
require 'src/states/game/gui/InventoryState'
require 'src/states/game/gui/QuestState'
require 'src/states/game/gui/ConfirmState'
require 'src/states/game/asthetic/DeathAnimationState'
require 'src/states/game/data/LoadState'
require 'src/states/game/data/SaveState'

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

require 'src/level/map/biomes/biome_defs'
require 'src/level/map/biomes/Biome'
require 'src/level/map/features/feature_defs'
require 'src/level/map/features/Feature'
require 'src/level/map/features/AnimatedFeature'
require 'src/level/map/features/GatewayFeature'
require 'src/level/map/tiles/tile_defs'
require 'src/level/map/tiles/Tile' 
require 'src/level/map/tiles/AnimatedTile'
require 'src/level/map/generation/generation_defs'
require 'src/level/map/generation/FeatureGenerator'
require 'src/level/map/generation/MapGenerator'
require 'src/level/map/structure/structure_defs'
require 'src/level/map/Map' 
require 'src/level/map/TileMap' 

require 'src/level/entity/Entity' 
require 'src/level/entity/entity_defs'
require 'src/level/entity/Player' 
require 'src/level/entity/combat/CombatEntity'
require 'src/level/entity/combat/StatLevel'
require 'src/level/entity/combat/enemy/EnemySpawner'
require 'src/level/entity/combat/enemy/Enemy'
require 'src/level/entity/combat/effect/Effect'
require 'src/level/entity/combat/effect/effect_defs'
require 'src/level/entity/combat/projectile/projectile_defs'
require 'src/level/entity/combat/projectile/Projectile'
require 'src/level/entity/combat/projectile/ProjectileManager'
require 'src/level/entity/npc/NPC'
require 'src/level/entity/npc/NPCManager'
require 'src/level/entity/npc/Shop'
require 'src/level/entity/npc/Quest'
require 'src/level/entity/item/item_defs'
require 'src/level/entity/item/Item'
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
    ['effects'] = love.graphics.newImage('graphics/effects/effects.png'),
    ['items'] = love.graphics.newImage('graphics/items/items.png'),
    ['edges'] = love.graphics.newImage('graphics/map/edges.png'),
    ['npc'] = love.graphics.newImage('graphics/entities/npc.png'),
    ['selector'] = love.graphics.newImage('graphics/gui/selector.png'),
    ['skeleton'] = love.graphics.newImage('graphics/entities/enemies/skeleton.png'),
    ['goblin'] = love.graphics.newImage('graphics/entities/enemies/goblin.png'),
    ['projectiles'] = love.graphics.newImage('graphics/entities/projectiles.png'),
    ['player_death'] = love.graphics.newImage('graphics/entities/player_death.png')
}

gFrames = {
    ['player'] = GenerateQuads(gTextures['player'], 16, 16),
    ['tiles'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
    ['features'] = GenerateQuads(gTextures['features'], FEATURE_SIZE, FEATURE_SIZE),
    ['goblin'] = GenerateQuads(gTextures['goblin'], 16, 16),
    ['effects'] = GenerateQuads(gTextures['effects'], 8, 8),
    ['items'] = GenerateQuads(gTextures['items'], 16, 16),
    ['edges'] = GenerateQuads(gTextures['edges'], 16, 16),
    ['npc'] = GenerateQuads(gTextures['npc'], 16, 16),
    ['selector'] = GenerateQuads(gTextures['selector'], 16, 16),
    ['skeleton'] = GenerateQuads(gTextures['skeleton'], 16, 16),
    ['projectiles'] = GenerateQuads(gTextures['projectiles'], 16, 16),
    ['player_death'] = GenerateQuads(gTextures['player_death'], 16, 16)
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
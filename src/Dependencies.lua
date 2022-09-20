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
require 'src/states/game/asthetic/CameraShiftState'
require 'src/states/game/asthetic/ConvergePointState'
require 'src/states/game/asthetic/DivergePointState'
require 'src/states/game/asthetic/GuiShiftState'
require 'src/states/game/asthetic/PauseUpdatesState'
require 'src/states/game/data/LoadState'
require 'src/states/game/data/SaveState'

require 'src/states/entity/EntityBaseState' 
require 'src/states/entity/EntityIdleState' 
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/EntityInteractState'
require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerWalkState'
require 'src/states/entity/player/PlayerItemState'
require 'src/states/entity/enemy/EnemyIdleState'
require 'src/states/entity/enemy/EnemyWalkState'
require 'src/states/entity/enemy/EnemySpawnState'
require 'src/states/entity/enemy/EnemyDespawnState'
require 'src/states/entity/npc/NPCIdleState' 
require 'src/states/entity/npc/NPCWalkState'

require 'src/level/Level' 
require 'src/level/Dungeon'
require 'src/level/Overworld'
require 'src/level/Camera'
require 'src/level/DungeonCamera'

require 'src/level/map/biomes/biome_defs'
require 'src/level/map/biomes/Biome'
require 'src/level/map/features/feature_defs'
require 'src/level/map/features/Feature'
require 'src/level/map/features/AnimatedFeature'
require 'src/level/map/features/GatewayFeature'
require 'src/level/map/features/SpawnFeature'
require 'src/level/map/tiles/tile_defs'
require 'src/level/map/tiles/Tile' 
require 'src/level/map/tiles/AnimatedTile'
require 'src/level/map/generation/generation_defs'
require 'src/level/map/generation/OverworldGenerator'
require 'src/level/map/generation/DungeonGenerator'
require 'src/level/map/structures/structure_defs'
require 'src/level/map/Map'
require 'src/level/map/DungeonMap'
require 'src/level/map/OverworldMap' 

require 'src/level/entity/Entity' 
require 'src/level/entity/entity_defs'
require 'src/level/entity/combat/CombatEntity'
require 'src/level/entity/combat/StatLevel'
require 'src/level/entity/combat/PushManager'
require 'src/level/entity/combat/InvincibilityManager'
require 'src/level/entity/combat/enemy/EntityManager'
require 'src/level/entity/combat/enemy/Enemy'
require 'src/level/entity/combat/effect/Effect'
require 'src/level/entity/combat/effect/EffectManager'
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
require 'src/level/entity/player/Player' 
require 'src/level/entity/player/QuestManager'

require 'src/gui/Panel'
require 'src/gui/Textbox'
require 'src/gui/Selection'
require 'src/gui/Menu'
require 'src/gui/menu_defs'
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
    ['wizard'] = love.graphics.newImage('graphics/entities/enemies/wizard.png'),
    ['projectiles'] = love.graphics.newImage('graphics/entities/projectiles.png'),
    ['player_death'] = love.graphics.newImage('graphics/entities/player_death.png'),
    ['smoke'] = love.graphics.newImage('graphics/entities/smoke.png')
}

gFrames = {
    ['player'] = GenerateQuads(gTextures['player'], 16, 16),
    ['tiles'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
    ['features'] = GenerateQuads(gTextures['features'], FEATURE_SIZE, FEATURE_SIZE),
    ['effects'] = GenerateQuads(gTextures['effects'], 8, 8),
    ['items'] = GenerateQuads(gTextures['items'], 16, 16),
    ['edges'] = GenerateQuads(gTextures['edges'], 16, 16),
    ['npc'] = GenerateQuads(gTextures['npc'], 16, 16),
    ['selector'] = GenerateQuads(gTextures['selector'], 16, 16),
    ['skeleton'] = GenerateQuads(gTextures['skeleton'], 16, 16),
    ['goblin'] = GenerateQuads(gTextures['goblin'], 16, 16),
    ['wizard'] = GenerateQuads(gTextures['wizard'], 16, 16),
    ['projectiles'] = GenerateQuads(gTextures['projectiles'], 16, 16),
    ['player_death'] = GenerateQuads(gTextures['player_death'], 16, 16),
    ['smoke'] = GenerateQuads(gTextures['smoke'], 16, 16)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}

gSounds = {
    ['gui'] = {
        ['menu_blip_1'] = love.audio.newSource('sounds/menu_blip_1.wav', 'static'),
        ['menu_select_1'] = love.audio.newSource('sounds/menu_select_1.wav', 'static'),
        ['level_up'] = love.audio.newSource('sounds/level_up.wav', 'static'),
        ['shop_exchange'] = love.audio.newSource('sounds/shop_exchange.wav', 'static'),
    },
    ['combat'] = {
        ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
        ['player_dies'] = love.audio.newSource('sounds/player_dies_1.wav', 'static'),
        ['enemy_dies'] = love.audio.newSource('sounds/enemy_dies.wav', 'static'),
        ['fire_hit_1'] = love.audio.newSource('sounds/fire_hit_1.wav', 'static'),
        ['target_found'] = love.audio.newSource('sounds/target_found.wav', 'static'),
        ['death_jingle'] = love.audio.newSource('sounds/death_jingle.wav', 'static')
    },
    ['items'] = {
        ['sword_swing_1'] = love.audio.newSource('sounds/sword_swing_1.wav', 'static'),
        ['pickup_item'] = love.audio.newSource('sounds/pickup_item.wav', 'static'),
        ['battle_axe'] = love.audio.newSource('sounds/battle_axe.wav', 'static'),
        ['bow_shot'] = love.audio.newSource('sounds/bow_shot.wav', 'static'),
        ['health'] = love.audio.newSource('sounds/health.wav', 'static'),
        ['money'] = love.audio.newSource('sounds/money.wav', 'static'),
        ['special_item'] = love.audio.newSource('sounds/special_item.wav', 'static'),
        ['use_magic'] = love.audio.newSource('sounds/use_magic.wav', 'static'),
    },
    ['world'] = {
        ['bridge'] = love.audio.newSource('sounds/bridge.wav', 'static'),
        ['enter_gateway'] = love.audio.newSource('sounds/enter_gateway.wav', 'static'),
        ['open_chest'] = love.audio.newSource('sounds/open_chest.wav', 'static'),
        ['tree_falls'] = love.audio.newSource('sounds/tree_falls.wav', 'static'),
    },
    ['music'] = {
        ['dungeon'] = love.audio.newSource('sounds/dungeon.mp3', 'stream'),
        ['underground'] = love.audio.newSource('sounds/underground.mp3', 'stream'),
        ['overworld'] = love.audio.newSource('sounds/overworld.mp3', 'stream')
    }
}
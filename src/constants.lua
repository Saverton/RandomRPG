--[[
    Base Constants data file for Love2D projects
    @author Saverton
]]

-- universal/technical
VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- map generation
TILE_SIZE = 16
FEATURE_SIZE = 16
MAP_OFFSET_X = 0
MAP_OFFSET_Y = 0
DEFAULT_MAP_SIZE = 100
OVERWORLD_TYPES = {'classic', 'wasteland', 'winter_wonderland', 'winter_wasteland'}
ROTATION_OFFSETS = {[0] = {x = 0, y = 0}, [90] = {x = 1, y = 0}, [180] = {x = 1, y = 1}, [270] = {x = 0, y = 1}}

-- dungeon generation
ROOM_WIDTH = 24
ROOM_HEIGHT = 14

-- camera
CAMERA_WIDTH = VIRTUAL_WIDTH
CAMERA_HEIGHT = VIRTUAL_HEIGHT
OFFSCREEN_CAM_WIDTH = 32
OFFSCREEN_CAM_HEIGHT = 32
DUNGEON_CAMERA_SHIFT_TIME = 1

-- entity
DEFAULT_ENTITY_WIDTH = 16
DEFAULT_ENTITY_HEIGHT = 16
DEFAULT_ENTITY_ROTATION = 0
DEFAULT_HP = 1
DEFAULT_SPEED = 16
DEFAULT_DEFENSE = 0
DEFAULT_ATTACK = 0
DEFAULT_MAGIC = 0
START_DIRECTION = 'down'
DEFAULT_ENTITY_CAP = 5
FLASH_FRAME = 4
INVINCIBLE_TIME = 0.5
PUSH_DECAY = 1.3
PROJECTILE_CAP = 5
INFO_TAG_Y_OFFSET = -15

-- player
PLAYER_WIDTH = DEFAULT_ENTITY_WIDTH - 6
PLAYER_HEIGHT = DEFAULT_ENTITY_HEIGHT - 6
PLAYER_X_OFFSET = -3
PLAYER_Y_OFFSET = -4
PLAYER_BASE_HP = 3
PLAYER_BASE_ATTACK = 0
PLAYER_BASE_SPEED = 80
PLAYER_BASE_DEFENSE = 0
PLAYER_BASE_MANA = 5
PLAYER_ANIMATION_SPEED = 0.1
PLAYER_SPAWN_X_OFFSET = 3
PLAYER_SPAWN_Y_OFFSET = 3
PLAYER_BAR_X = 34
PLAYER_BAR_HEIGHT = 4
PLAYER_HP_BAR_HEIGHT = 6
PLAYER_BAR_WIDTH = 40
PLAYER_HP_BAR_Y = 12
PLAYER_MANA_BAR_Y = 12 + PLAYER_HP_BAR_HEIGHT + 4
PLAYER_LVL_TEXT_Y = PLAYER_MANA_BAR_Y + PLAYER_BAR_HEIGHT + 2
PLAYER_EXP_TEXT_Y = PLAYER_LVL_TEXT_Y + 8 + 2
PLAYER_EXP_BAR_Y = PLAYER_EXP_TEXT_Y + 8 + 2
START_AMMO = 10
PLAYER_TEXT_POS_X = 34
AMMO_TEXT_POS_Y = PLAYER_EXP_BAR_Y + PLAYER_BAR_HEIGHT + 6
MONEY_TEXT_POS_Y = AMMO_TEXT_POS_Y + 8 + 8

-- animations
DEFAULT_ANIMATION_SPEED = 0.2

-- directions 
DIRECTIONS = {[1] = 'up', [2] = 'right', [3] = 'down', [4] = 'left'}
DIRECTION_TO_NUM = {['up'] = 1, ['right'] = 2, ['down'] = 3, ['left'] = 4}
DIRECTION_COORDS = {{x = 0, y = -1}, {x = 1, y = 0}, {x = 0, y = 1}, {x = -1, y = 0}}

-- enemy
DEFAULT_ENEMY_AGRO_DIST = 5
MAX_SPAWN_RANGE = 20
MIN_SPAWN_RANGE = 10
DESPAWN_RANGE = 25 * TILE_SIZE
SPAWN_TIME = 1
DESPAWN_TIME = 0.8

-- gui
BAR_WIDTH = 16 -- for progress bars
BAR_HEIGHT = 2
SELECTION_HEIGHT = 8
SELECTION_MARGIN = 3
IMAGEBOX_X = 5
TEXTBOX_MARGIN = 5
IMAGEBOX_MARGIN = TEXTBOX_MARGIN
IMAGEBOX_SIZE = 32 + (2 * IMAGEBOX_MARGIN)
TEXTBOX_HEIGHT = (4 * TEXTBOX_MARGIN) + (3 * 8)
TEXTBOX_X = IMAGEBOX_X + IMAGEBOX_SIZE + 5
TEXTBOX_Y = VIRTUAL_HEIGHT - TEXTBOX_HEIGHT - 5
TEXTBOX_WIDTH = VIRTUAL_WIDTH - 5 - TEXTBOX_X
IMAGEBOX_Y = TEXTBOX_Y
MENU_WIDTH = 150
MENU_HEIGHT = VIRTUAL_HEIGHT - 20
MENU_X = VIRTUAL_WIDTH / 2 - MENU_WIDTH / 2
MENU_Y = 10
HOTBAR_X = 10
HOTBAR_Y = 10
HOTBAR_MARGIN = 3
HOTBAR_PANEL_SIZE = 20
TIPTEXT_X = 5
TIPTEXT_Y = VIRTUAL_HEIGHT - 13
TEXT_REVEAL_SPEED = 20 -- chars/second

-- items
PICKUP_RENDER_RANGE = 15
PICKUP_RANGE = 16
CHEST_ITEMS = {'sword', 'battle_axe', 'bow', 'fire_tome', 'ice_tome'}

-- npcs
DESPAWN_TIMER = 2
NPC_CAP = 1
NPC_TYPES = {'shop'}
NPC_NAMES = {'Dorfinkle', 'Adronian', 'Quandale', 'Steve', 'Terrence', 'Dumbledalf', 'Frippin', 'Zink'}
--[[ QUEST_LIMIT = 2
TIPS = {
    'Have you found six weapons?',
    'Tomes inflict status effects.',
    'A Battle Axe is not just a weapon...',
    'Don\'t get too close to skeletons.',
    'Enemies will get stronger too!',
    'Have you visited a dungeon?'
} -- unused currently, may be added to quest or shop npc dialog ]]

-- leveling
DEFAULT_BONUS = 1

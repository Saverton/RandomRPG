--[[
    Base Constants data file for Love2D projects
    @author Saverton
]]

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

TILE_SIZE = 16
FEATURE_SIZE = 16

MAP_OFFSET_X = 0
MAP_OFFSET_Y = 0

CAMERA_WIDTH = VIRTUAL_WIDTH
CAMERA_HEIGHT = VIRTUAL_HEIGHT
OFFSCREEN_CAM_WIDTH = 32
OFFSCREEN_CAM_HEIGHT = 32

DEFAULT_MAP_SIZE = 50

MOUNTAIN_MIN_SIZE = 5
MOUNTAIN_MAX_SIZE = 10

DEFAULT_ENTITY_WIDTH = 16
DEFAULT_ENTITY_HEIGHT = 16
DEFAULT_ENTITY_ROTATION = 0

PLAYER_WIDTH = DEFAULT_ENTITY_WIDTH - 6
PLAYER_HEIGHT = DEFAULT_ENTITY_HEIGHT - 6
PLAYER_X_OFFSET = -3
PLAYER_Y_OFFSET = -4
PLAYER_BASE_HP = 5
PLAYER_BASE_ATTACK = 1
PLAYER_BASE_SPEED = 64
PLAYER_BASE_DEFENSE = 0
PLAYER_BASE_MAGIC = 5
-- for use if tweaking hitbox
PLAYER_HITBOX_X_OFFSET = 0
PLAYER_HITBOX_Y_OFFSET = 0
PLAYER_HITBOX_XB_OFFSET = 0
PLAYER_HITBOX_YB_OFFSET = 0

DEFAULT_ANIMATION_SPEED = 0.2
PLAYER_ANIMATION_SPEED = 0.2

DEFAULT_HP = 1
DEFAULT_SPEED = 1
DEFAULT_DEFENSE = 0
DEFAULT_ATTACK = 1
DEFAULT_MAGIC = 0

START_DIRECTION = 'down'

DIRECTIONS = {
    [1] = 'up',
    [2] = 'right',
    [3] = 'down',
    [4] = 'left'
}
DIRECTION_TO_NUM = {
    ['up'] = 1,
    ['right'] = 2,
    ['down'] = 3,
    ['left'] = 4
}

DIRECTION_COORDS = {
    {0, -1}, {1, 0}, {0, 1}, {-1, 0}
}

DEFAULT_ENEMY_AGRO_DIST = 5

DEFAULT_ENTITY_CAP = 5

SPAWN_RANGE = 20
DESPAWN_RANGE = 25 * TILE_SIZE

DEFAULT_SPAWN_POS = {
    x = 1,
    y = 1
}

PLAYER_SPAWN_X = 5
PLAYER_SPAWN_Y = 5
PLAYER_SPAWN_X_OFFSET = 3
PLAYER_SPAWN_Y_OFFSET = 3

BAR_WIDTH = 16
BAR_HEIGHT = 2
PLAYER_BAR_X = 34
PLAYER_BAR_HEIGHT = 6
PLAYER_BAR_WIDTH = 40
PLAYER_HP_BAR_Y = 12
PLAYER_MAGIC_BAR_Y = 12 + PLAYER_BAR_HEIGHT + 5

ATTACK_TIME = 0.3
FLASH_FRAME = 4
INVINCIBLE_TIME = 0.5

SAFE_RANGE = 9

PUSH_DECAY = 1.1

START_AMMO = 10

PLAYER_TEXT_POS_X = 34
AMMO_TEXT_POS_Y = PLAYER_MAGIC_BAR_Y + PLAYER_BAR_HEIGHT + 5
MONEY_TEXT_POS_Y = AMMO_TEXT_POS_Y + 8 + 2

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

PICKUP_RENDER_RANGE = 15
PICKUP_RANGE = 16

DESPAWN_TIMER = 2

NPC_CAP = 3
NPC_TYPES = {'quest'}
NPC_NAMES = {'Dorfinkle', 'Adronian', 'Quandale', 'Steve', 'Terrence', 'Dumbledalf', 'Frippin', 'Zink'}

QUEST_LIMIT = 2

TIPS = {
    'There are three different weapons scattered across the world.',
    'The Tome of Fire doesn\'t harm enemies directly, but it sets them on fire for a brief time.',
    'There aren\' too many tips for me to give you, the game is still rather simple.',
    'You can chop down a tree using the Battle Axe...',
    'You can use wood to bridge across water...',
    'Watch out for skeletons! They have weapons!'
}

CHEST_ITEMS = {'sword', 'battle_axe', 'bow', 'fire_tome', 'ice_tome'}

PROJECTILE_CAP = 5
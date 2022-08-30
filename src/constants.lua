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
PLAYER_BASE_HP = 3
PLAYER_BASE_SPEED = 64
PLAYER_BASE_DEFENSE = 0
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

HEALTH_BAR_WIDTH = 16
HEALTH_BAR_HEIGHT = 2

ATTACK_TIME = 0.3
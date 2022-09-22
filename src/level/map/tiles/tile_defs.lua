--[[
    Definitions for every tile in the game.
    @author Saverton
]]
TILE_DEFS = {
    ['grass'] = {
        name = 'grass',
        texture = 'tiles',
        frame = 1,
        barrier = false,
        onInteract = function() end
    },
    ['water'] = {
        name = 'water',
        texture = 'tiles',
        frame = 3,
        barrier = true,
        animated = true,
        onInteract = function(player, map, col, row)
            local tiles = map.tileMap.tiles
            local item = player.items[player.heldItem]
            if item ~= nil and item.name == 'wood' and item.quantity > 0 then
                gSounds['world']['bridge']:play()
                item.quantity = math.max(0, item.quantity - 1)
                tiles[col][row] = Tile('bridge', col, row)
                player:updateInventory()
                return true
            end

            return false
        end
    },
    ['stone'] = {
        name = 'stone',
        texture = 'tiles',
        frame = 2,
        barrier = false,
        onInteract = function() end
    },
    ['bridge'] = {
        name = 'bridge',
        texture = 'tiles',
        frame = 5,
        barrier = false,
        onInteract = function() end
    },
    ['sand'] = {
        name = 'sand',
        texture = 'tiles',
        frame = 6,
        barrier = false,
        onInteract = function() end
    },
    ['snow'] = {
        name = 'snow',
        texture = 'tiles',
        frame = 7,
        barrier = false,
        onInteract = function() end
    },
    ['wall_inside'] = {
        name = 'wall_inside',
        texture = 'tiles',
        frame = 8,
        barrier = true,
        wall = true,
        onInteract = function() end
    },
    ['wall_block'] = {
        name = 'wall_block',
        texture = 'tiles',
        frame = 9,
        barrier = true,
        wall = true,
        onInteract = function() end
    },
    ['floor'] = {
        name = 'floor',
        texture = 'tiles',
        frame = 10,
        barrier = false,
        onInteract = function() end
    },
    ['wall_side'] = {
        name = 'wall_side',
        texture = 'tiles',
        frame = 11,
        barrier = true,
        wall = true,
        onInteract = function() end
    },
    ['wall_corner'] = {
        name = 'wall_corner',
        texture = 'tiles',
        frame = 12,
        barrier = true,
        wall = true,
        onInteract = function() end
    }
}
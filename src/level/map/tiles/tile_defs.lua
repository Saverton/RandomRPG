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
        onInteract = function() end,
        mapColor = {56/255, 143/255, 60/255}
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
        end,
        mapColor = {91/255, 96/255, 245/255}
    },
    ['stone'] = {
        name = 'stone',
        texture = 'tiles',
        frame = 2,
        barrier = false,
        onInteract = function() end,
        mapColor = {103/255, 104/255, 110/255}
    },
    ['bridge'] = {
        name = 'bridge',
        texture = 'tiles',
        frame = 5,
        barrier = false,
        onInteract = function() end,
        mapColor = {74/255, 36/255, 27/255}
    },
    ['sand'] = {
        name = 'sand',
        texture = 'tiles',
        frame = 6,
        barrier = false,
        onInteract = function() end,
        mapColor = {227/255, 102/255, 73/255}
    },
    ['snow'] = {
        name = 'snow',
        texture = 'tiles',
        frame = 7,
        barrier = false,
        onInteract = function() end,
        mapColor = {1, 1, 1}
    },
    ['wall_inside'] = {
        name = 'wall_inside',
        texture = 'tiles',
        frame = 8,
        barrier = true,
        wall = true,
        onInteract = function() end,
        mapColor = {0, 0, 0}
    },
    ['wall_block'] = {
        name = 'wall_block',
        texture = 'tiles',
        frame = 9,
        barrier = true,
        wall = true,
        onInteract = function() end,
        mapColor = {66/255, 66/255, 66/255}
    },
    ['floor'] = {
        name = 'floor',
        texture = 'tiles',
        frame = 10,
        barrier = false,
        onInteract = function() end,
        mapColor = {150/255, 150/255, 150/255}
    },
    ['wall_side_left'] = {
        name = 'wall_side_left',
        texture = 'tiles',
        frame = 11,
        barrier = true,
        wall = true,
        onInteract = function() end,
        mapColor = {66/255, 66/255, 66/255}
    },
    ['wall_side_right'] = {
        name = 'wall_side_right',
        texture = 'tiles',
        frame = 12,
        barrier = true,
        wall = true,
        onInteract = function() end,
        mapColor = {66/255, 66/255, 66/255}
    },
    ['wall_side'] = {
        name = 'wall_side',
        texture = 'tiles',
        frame = 14,
        barrier = true,
        wall = true,
        onInteract = function() end,
        mapColor = {66/255, 66/255, 66/255}
    },
    ['wall_corner'] = {
        name = 'wall_corner',
        texture = 'tiles',
        frame = 13,
        barrier = true,
        wall = true,
        onInteract = function() end,
        mapColor = {66/255, 66/255, 66/255}
    }
}
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
    }
}
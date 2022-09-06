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
        onInteract = function(player, tiles, col, row)
            local item = player.items[player.heldItem]
            if item ~= nil and item.name == 'wood' and item.quantity > 0 then
                item.quantity = math.max(0, item.quantity - 1)
                tiles[col][row] = Tile(TILE_DEFS['bridge'], col, row)
                player:updateInventory()
            end
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
        frame = 4,
        barrier = false,
        onInteract = function() end
    }
}
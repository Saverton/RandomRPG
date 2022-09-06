--[[
    Definitions for all world features in the game.
    @author Saverton
]]

FEATURE_DEFS = {
    ['empty'] = {
        id = 0,
        name = 'empty',
        texture = 'empty',
        frame = 0,
        onInteract = function() end,
        isSolid = false
    },
    ['tree'] = {
        id = 1,
        name = 'tree',
        texture = 'features',
        frame = 1,
        onInteract = function(player, featureMap, col, row) 
            if player.items[player.heldItem].name == 'battle_axe' then
                featureMap[col][row] = nil
                table.insert(player.level.pickupManager.pickups, Pickup('wood', (col - 1) * TILE_SIZE, (row - 1) * TILE_SIZE))
            end
        end,
        isSolid = false
    },
    ['rock'] = {
        id = 2,
        name = 'rock',
        texture = 'features',
        frame = 2,
        onInteract = function() end,
        isSolid = true
    },
    ['chest'] = {
        id = 3,
        name = 'chest',
        texture = 'features',
        frame = 3,
        onInteract = function(player, featureMap, col, row)
            featureMap[col][row] = nil
            table.insert(player.level.pickupManager.pickups, Pickup(CHEST_ITEMS[math.random(#CHEST_ITEMS)], 
                (col - 1) * TILE_SIZE, (row - 1) * TILE_SIZE))
            table.insert(player.level.pickupManager.pickups, Pickup('ammo', 
                (col - 1) * TILE_SIZE, (row - 1) * TILE_SIZE, math.random(5, 10)))
        end,
        isSolid = true
    }
}
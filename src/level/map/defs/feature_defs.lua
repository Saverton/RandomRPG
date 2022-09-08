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
        onInteract = function(player, map, col, row) 
            local featureMap = map.featureMap
            if player.items[player.heldItem].name == 'battle_axe' then
                featureMap[col][row] = nil
                table.insert(player.level.pickupManager.pickups, Pickup('wood', (col - 1) * TILE_SIZE, (row - 1) * TILE_SIZE))
                return true
            end

            return false
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
        animated = true,
        onInteract = function(player, map, col, row)
            local featureMap = map.featureMap
            featureMap[col][row].animation:changeAnimation('open')
            Timer.after(1.5, function()
                featureMap[col][row].animation:changeAnimation('main')
                featureMap[col][row] = nil 
                table.insert(player.level.pickupManager.pickups, Pickup(CHEST_ITEMS[math.random(#CHEST_ITEMS)], 
                (col - 1) * TILE_SIZE, (row - 1) * TILE_SIZE))
                table.insert(player.level.pickupManager.pickups, Pickup('ammo', 
                    (col - 1) * TILE_SIZE, (row - 1) * TILE_SIZE, math.random(5, 10)))
            end)
        end,
        isSolid = true
    },
    ['cactus'] = {
        id = 4,
        name = 'cactus',
        texture = 'features',
        frame = 8,
        onInteract = function() end,
        isSolid = false
    },
    ['snow_tree'] = {
        id = 1,
        name = 'snow_tree',
        texture = 'features',
        frame = 7,
        onInteract = function(player, map, col, row) 
            local featureMap = map.featureMap
            if player.items[player.heldItem].name == 'battle_axe' then
                featureMap[col][row] = nil
                table.insert(player.level.pickupManager.pickups, Pickup('wood', (col - 1) * TILE_SIZE, (row - 1) * TILE_SIZE))
                return true
            end

            return false
        end,
        isSolid = false
    },
    ['fortress'] = {
        id = 5,
        name = 'fortress',
        texture = 'features',
        frame = 9,
        gateway = true,
        onInteract = function() end,
        isSolid = false
    }
}
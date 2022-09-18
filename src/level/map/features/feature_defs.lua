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
        onCollide = function() end,
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
                gSounds['world']['tree_falls']:play()
                featureMap[col][row] = nil
                table.insert(player.level.pickupManager.pickups, Pickup('wood', (col - 1) * TILE_SIZE, (row - 1) * TILE_SIZE))
                return true
            end

            return false
        end,
        onCollide = function() end,
        isSolid = false
    },
    ['rock'] = {
        id = 2,
        name = 'rock',
        texture = 'features',
        frame = 2,
        onInteract = function() end,
        onCollide = function() end,
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
            if featureMap[col][row].animation.currentAnimation == 'open' then
                return
            end
            featureMap[col][row].animation:changeAnimation('open')
            gSounds['world']['open_chest']:play()
            Timer.after(1.5, function()
                featureMap[col][row].animation:changeAnimation('main')
                featureMap[col][row] = nil 
                player.level.pickupManager:spawnPickups({
                    {name = CHEST_ITEMS[math.random(#CHEST_ITEMS)], x = (col - 1) * TILE_SIZE, y = (row - 1) * TILE_SIZE},
                    {name = 'ammo', x = (col - 1) * TILE_SIZE, y = (row - 1) * TILE_SIZE, quantity = math.random(5, 10)}})
            end)
        end,
        onCollide = function() end,
        isSolid = true
    },
    ['cactus'] = {
        id = 4,
        name = 'cactus',
        texture = 'features',
        frame = 8,
        onInteract = function() end,
        onCollide = function() end,
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
                gSounds['world']['tree_falls']:play()
                featureMap[col][row] = nil
                table.insert(player.level.pickupManager.pickups, Pickup('wood', (col - 1) * TILE_SIZE, (row - 1) * TILE_SIZE))
                return true
            end
            return false
        end,
        onCollide = function() end,
        isSolid = false
    },
    ['fortress'] = {
        id = 5,
        name = 'fortress',
        texture = 'features',
        frame = 9,
        gateway = true,
        onInteract = function() end,
        onCollide = function(entity, feature)
            if entity.isPlayer then
                feature:onEnter(entity.level) -- if the entity that collides with this is a player, call the gateway function
            end
        end,
        isSolid = false
    },
    ['exit'] = {
        id = 6,
        name = 'exit',
        texture = 'features',
        frame = 10,
        gateway = true,
        onInteract = function() end,
        onCollide = function(entity, feature)
            if entity.isPlayer then
                feature:onEnter(entity.level) -- if the entity that collides with this is a player, call the gateway function
            end
        end,
        isSolid = false
    },
    ['spawner'] = {
        id = 7,
        name = 'spawner',
        texture = 'features',
        frame = 11,
        spawner = true,
        onInteract = function() end,
        onCollide = function() end,
        isSolid = false
    },
    ['key_door'] = {
        id = 8,
        name = 'key_door',
        texture = 'features',
        frame = 12,
        onInteract = function(player, map, col, row)
            local featureMap = map.featureMap
            if player.items[player.heldItem].name == 'key' then
                featureMap[col][row] = nil
                player.items[player.heldItem].quantity = player.items[player.heldItem].quantity - 1
                player:updateInventory()
                return true
            end
            return false
        end,
        onCollide = function() end,
        isSolid = true
    }
}